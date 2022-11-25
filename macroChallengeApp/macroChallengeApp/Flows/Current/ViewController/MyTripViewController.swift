//
//  MyTripViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import CoreData

class MyTripViewController: UIViewController, NSFetchedResultsControllerDelegate{
    weak var coordinator: ProfileCoordinator?
    weak var coordinatorCurrent: CurrentCoordinator?
    let network: NetworkMonitor = NetworkMonitor.shared
    let user = UserRepository.shared.getUser()

    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let myTripView = MyTripView()
    let detailView = DetailView()
    
    var roadmap = RoadmapLocal()
    var activites: [ActivityLocal] = []
    var days: [DayLocal] = []
    var daySelected = 0
    var budgetTotal: Double = 0
    let currencyController = CurrencyController()
    let tutorialEnable = UserDefaults.standard.bool(forKey: "tutorialMyTrip")
    
    lazy var userCurrency: String = {
        let userC = currencyController.getUserCurrency()
        return userC
    }()
    
    private lazy var fetchResultController: NSFetchedResultsController<RoadmapLocal> = {
        let request: NSFetchRequest<RoadmapLocal> = RoadmapLocal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RoadmapLocal.createdAt, ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: RoadmapRepository.shared.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        network.startMonitoring()
        super.viewDidLoad()
        self.setupMyTripView()
        do {
            try fetchResultController.performFetch()
        } catch {
            fatalError("Não foi possível atualizar conteúdo")
        }
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
        updateConstraintsTable()
        myTripView.secondTutorialTitle.addTarget(self, action: #selector(tutorialSecond), for: .touchUpInside)
        myTripView.tutorialTitle.addTarget(self, action: #selector(tutorial), for: .touchUpInside)
    }
    
    func updateConstraintsTable() {
        let height = 100 * activites.count
        
        myTripView.activitiesTableView.snp.removeConstraints()
        myTripView.activitiesTableView.snp.makeConstraints { make in
            make.top.equalTo(myTripView.budgetView.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(myTripView.contentView.snp.leading)
            make.trailing.equalTo(myTripView.contentView.snp.trailing)
            make.bottom.equalTo(myTripView.scrollView.snp.bottom)
            make.height.equalTo(height)
        }
    }
    func getAllDays() {
        if var newDays = roadmap.day?.allObjects as? [DayLocal] {
            newDays.sort { $0.id < $1.id }
            self.days = newDays
        }
        for index in 0..<days.count where days[index].isSelected == true {
            self.daySelected = index
            myTripView.dayTitle.text = "Day ".localized() + String(daySelected + 1)
        }
    }
    
    func getAllActivities() -> [ActivityLocal] {
        guard var newActivities = days[daySelected].activity?.allObjects as? [ActivityLocal] else {
            return []
        }
        newActivities.sort { $0.hour ?? "1" < $1.hour ?? "2" }
        self.myTripView.dayTitle.text = "Day ".localized() + String(daySelected + 1)
        self.myTripView.activitiesTableView.reloadData()
        return newActivities
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
    
    func emptyState(activities: [ActivityLocal]) {
        if activities.isEmpty {
            if UIDevice.current.name == "iPhone SE (3rd generation)" || UIDevice.current.name == "iPhone 8" {
                myTripView.emptyStateImage.snp.removeConstraints()
                myTripView.emptyStateImage.snp.makeConstraints { make in
                    make.height.equalTo(UIScreen.main.bounds.height / 9)
                    make.centerX.equalToSuperview()
                    make.top.equalTo(myTripView.dayTitle.snp.bottom)
                }
            } else {
                myTripView.emptyStateImage.snp.removeConstraints()
                myTripView.emptyStateImage.snp.makeConstraints { make in
                    make.height.equalTo(UIScreen.main.bounds.height / 7)
                    make.centerX.equalToSuperview()
                    make.top.equalTo(myTripView.dayTitle.snp.bottom).inset(-40)
                }

            }
            myTripView.activitiesTableView.isHidden = true
            myTripView.budgetView.isHidden = true
            myTripView.emptyStateTitle.isHidden = false
            myTripView.emptyStateImage.isHidden = false

        } else {
            if tutorialEnable == false {
                self.tutorialTimer()
            }
            myTripView.activitiesTableView.isHidden = false
            myTripView.budgetView.isHidden = false
            myTripView.emptyStateTitle.isHidden = true
            myTripView.emptyStateImage.isHidden = true
            myTripView.scrollView.isScrollEnabled = true
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
            let introduction = "Hey! Join my itinerary in Wimbi app using the code: ".localized() + (roadmap.shareKey ?? "0")
            let activityItem = MyActivityItemSource(title: "Share your itinerary code!".localized(), text: introduction)
            let activityViewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = []
            self.roadmap.isShared = true
            FirebaseManager.shared.createAnalyticsEvent(event: "share_roadmap")
            RoadmapRepository.shared.saveContext()
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            let action = UIAlertController(title: "To share this itinerary, turn it public".localized(), message: nil, preferredStyle: .actionSheet)
            action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(action, animated: true)
        }
    }
    func updateAllBudget() {
        Task {
            var budgetDay = 0.0
            await budgetDay = currencyController.updateBudget(activites: activites, userCurrency: self.userCurrency)
            await budgetTotal = currencyController.updateBudgetTotal(userCurrency: self.userCurrency, days: days)
            roadmap.budget = budgetTotal
            RoadmapRepository.shared.saveContext()
            
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
}

extension MyTripViewController: ReviewTravelDelegate {
    func updateRoadmapScreen(roadmap: RoadmapLocal) {
        self.roadmap = roadmap
        self.getAllDays()
        self.activites = self.getAllActivities()
        self.emptyState(activities: activites)
        Task {
            await currencyController.updateBudget(activites: activites, userCurrency: self.userCurrency)
        }
        self.updateTotalBudgetValue()
        
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 2)])
        myTripView.calendarCollectionView.reloadData()
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // let newRoadmaps = RoadmapRepository.shared.getRoadmap()
        guard let newRoadmaps = controller.fetchedObjects as? [RoadmapLocal] else { return }
        self.roadmap = self.findRoadmap(roadmaps: newRoadmaps) ?? self.roadmap
        
    }
    func findRoadmap(roadmaps: [RoadmapLocal]) -> RoadmapLocal? {
        for roadmap in roadmaps where roadmap.name == self.roadmap.name { return roadmap }
        return nil
    }
}
