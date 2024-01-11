//
//  MyTripViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import WeatherKit

class MyTripViewController: UIViewController, NSFetchedResultsControllerDelegate {
    weak var coordinator: ProfileCoordinator?
    weak var coordinatorCurrent: CurrentCoordinator?
    let network: NetworkMonitor = NetworkMonitor.shared
    let user = UserRepository.shared.getUser()
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let myTripView = MyTripView()
    let detailView = DetailView()
    
    var roadmap = Roadmap()
    var activites: [Activity] = []
    var days: [Day] = []
    var daySelected = 0
    var budgetTotal: Double = 0
    let currencyController = CurrencyController()
    let tutorialEnable = UserDefaults.standard.bool(forKey: "tutorialMyTrip")
    var location = CLLocation(latitude: 37.7749, longitude: 122.4194)
    
    func getDayWeather( ) -> MyDayWeather {
        if #available(iOS 16.0, *) {
            let day = WeatherViewModel.shared.dayWeather
            if !day.isEmpty {
                return MyDayWeather(higherTemperature: day[0].highTemperature.value, lowerTemperature: day[0].lowTemperature.value, rainfall: day[0].precipitationChance)
            }
        }
        return MyDayWeather(higherTemperature: 0, lowerTemperature: 0, rainfall: 0)
    }
    
    func getCurrentyWeather( ) -> MyCurrentWeather {
        if #available(iOS 16.0, *) {
            let current = WeatherViewModel.shared.currentWeather
            return MyCurrentWeather(temperature: current?.temperature.value ?? 0, condition: current?.condition.rawValue ?? "")
        } else {
            return MyCurrentWeather(temperature: 0, condition: "")
        }
    }
    
    lazy var userCurrency: String = {
        let userC = currencyController.getUserCurrency()
        return userC
    }()
    
    override func loadView() {
        self.view = myTripView
    }
    
    override func viewDidLoad() {
        network.startMonitoring()
        super.viewDidLoad()
        self.setupMyTripView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.startMonitoring()
        self.getAllDays()
        self.activites = self.getAllActivities()
        self.emptyState(activities: activites)
        self.updateTotalBudgetValue()
        self.myTripView.activitiesTableView.reloadData()
        self.myTripView.activitiesTableView.layoutIfNeeded()
        self.updateAllBudget()
        
        if #available(iOS 16.0, *) {
            Task {
                await WeatherViewModel.shared.getDayWeather(roadmap.location)
                await WeatherViewModel.shared.getCurrentWeather(roadmap.location)
                myTripView.weatherView.actualTemperature = String(Int(getCurrentyWeather().temperature))
                print(getCurrentyWeather().condition)
                myTripView.weatherView.changeIcon(getCurrentyWeather().condition)
                myTripView.weatherView.higherTemperature = String(Int(getDayWeather().higherTemperature))
                myTripView.weatherView.lowerTemperature = String(Int(getDayWeather().lowerTemperature))
                myTripView.weatherView.rainfallLevel = String(getDayWeather().rainfall)
            }
        } else {
            // Fallback on earlier versions
        }
        
        myTripView.updateConstraintsTable(multiplier: activites.count)
        myTripView.secondTutorialTitle.addTarget(self, action: #selector(tutorialSecond), for: .touchUpInside)
        myTripView.tutorialTitle.addTarget(self, action: #selector(tutorial), for: .touchUpInside)
        
    }
    
    func getAllDays() {
        var newDays = roadmap.days
        newDays.sort { $0.id < $1.id }
        self.days = newDays
        
        for index in 0..<days.count where days[index].isSelected == true {
            self.daySelected = index
            myTripView.dayTitle.text = "Day ".localized() + String(daySelected + 1)
        }
    }
    
    func getAllActivities() -> [Activity] {
        if !days.isEmpty {
            var newActivities = days[daySelected].activity
            newActivities.sort { $0.hour < $1.hour }
            self.myTripView.dayTitle.text = "Day ".localized() + String(daySelected + 1)
            self.myTripView.activitiesTableView.reloadData()
            return newActivities
        }
        return []
    }
    
    func tutorialTimer() {
        UserDefaults.standard.set(true, forKey: "tutorialMyTrip")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.myTripView.secondTutorialView.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.myTripView.tutorialView.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.myTripView.tutorialView.removeFromSuperview()
            self.myTripView.secondTutorialView.removeFromSuperview()
            
        }
    }
    
    @objc func tutorial() {
        UserDefaults.standard.set(true, forKey: "tutorialMyTrip")
        myTripView.tutorialView.removeFromSuperview()
    }
    
    @objc func tutorialSecond() {
        UserDefaults.standard.set(true, forKey: "tutorialMyTrip")
        myTripView.secondTutorialView.removeFromSuperview()
    }
    
    func emptyState(activities: [Activity]) {
        if activities.isEmpty {
            myTripView.setEmptyView()
        } else {
            if tutorialEnable == false { self.tutorialTimer() }
            myTripView.setupActivityTable()
        }
    }
    
    @objc func goToCreateActivity() {
        coordinator?.startActivity(roadmap: self.roadmap, day: self.days[daySelected], delegate: self)
        coordinatorCurrent?.startActivity(roadmap: self.roadmap, day: self.days[daySelected], delegate: self)
        
    }
    
    @objc func editMyTrip() {
        coordinator?.editRoadmap(editRoadmap: self.roadmap, delegate: self)
        coordinatorCurrent?.editRoadmap(editRoadmap: self.roadmap, delegate: self)
        
    }
    
    @objc func shareMyTrip() {
        if roadmap.isPublic {
            let action = UIAlertController(title: "Share this itinerary".localized(), message: nil, preferredStyle: .actionSheet)
            action.addAction(UIAlertAction(title: "Generate share code".localized(), style: .default, handler: {(_: UIAlertAction!) in
                self.present(self.generateShareCode(), animated: true, completion: nil)
            }))
            ///Commented to archive in app store
            //            action.addAction(UIAlertAction(title: "Share itinerary link".localized(), style: .default, handler: {(_: UIAlertAction!) in
            //                #warning("add deeplink")
            //            }))
            action.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
            present(action, animated: true)
        } else {
            let action = UIAlertController(title: "To share this itinerary, turn it public".localized(), message: nil, preferredStyle: .actionSheet)
            action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(action, animated: true)
        }
    }
    func updateAllBudget() {
        Task {
            var budgetDay = 0.0
            await budgetDay = currencyController.updateBudgetBackend(activites: activites, userCurrency: self.userCurrency)
            await budgetTotal = currencyController.updateBudgetTotal(userCurrency: self.userCurrency, days: days)
            RoadmapRepository.shared.updateRoadmapBudget(roadmap: roadmap, budget: budgetTotal)
            let content = String(format: "\(self.userCurrency)%.2f", budgetDay)
            myTripView.budgetValue.text = content
            self.updateTotalBudgetValue()
        }
    }
    
    func updateTotalBudgetValue() {
        guard let cell = myTripView.infoTripCollectionView.cellForItem(at: [0, 1]) as? InfoTripCollectionViewCell else { return }
        let content = String(format: "\(self.userCurrency)%.2f", self.budgetTotal)
        cell.infoTitle.text = content
    }
    
    func generateShareCode() -> UIActivityViewController {
        let introduction = "Hey! Join my itinerary in Wimbi app using the code: ".localized() + self.roadmap.shareKey
        let activityItem = MyActivityItemSource(title: "Share your itinerary code!".localized(), text: introduction)
        let activityViewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        self.roadmap.isShared = true
        FirebaseManager.shared.createAnalyticsEvent(event: "share_roadmap")
        return activityViewController
    }
}

extension MyTripViewController: ReviewTravelDelegate {
    func updateRoadmapScreen(roadmap: Roadmap) {
        self.roadmap = roadmap
        self.getAllDays()
        self.activites = self.getAllActivities()
        self.emptyState(activities: activites)
        Task {
            await currencyController.updateBudgetBackend(activites: activites, userCurrency: self.userCurrency)
        }
        self.updateTotalBudgetValue()
        
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 2)])
        myTripView.calendarCollectionView.reloadData()
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        #warning("COREDATA: Corrigir funcao para pegar roadmaps do usuario")
        let newRoadmaps = RoadmapRepository.shared.getRoadmap()
        self.roadmap = self.findRoadmap(roadmaps: newRoadmaps) ?? self.roadmap
        
    }
    func findRoadmap(roadmaps: [Roadmap]) -> Roadmap? {
        for roadmap in roadmaps where roadmap.name == self.roadmap.name { return roadmap }
        return nil
    }
}
