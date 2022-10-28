//
//  MyTripViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit

class MyTripViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    weak var coordinatorCurrent: CurrentCoordinator?
    let network: NetworkMonitor = NetworkMonitor.shared

    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let myTripView = MyTripView()
    let detailView = DetailView()
    
    var roadmap = RoadmapLocal()
    var activites: [ActivityLocal] = []
    var days: [DayLocal] = []
    var daySelected = 0
    var budgetTotal: Double = 0
    let currencyController = CurrencyController()
    
    lazy var userCurrency: String = {
        let userC = currencyController.getUserCurrency()
        return userC
    }()
    
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
        updateConstraintsTable()
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
            print(newDays)
            self.days = newDays
        }
        for index in 0..<days.count where days[index].isSelected == true {
            self.daySelected = index
            myTripView.dayTitle.text = "Day ".localized() + String(daySelected + 1)
        }
    }
    
    func getAllActivities() -> [ActivityLocal] {
        if var newActivities = days[daySelected].activity?.allObjects as? [ActivityLocal] {
            newActivities.sort { $0.hour ?? "1" < $1.hour ?? "2" }
            myTripView.dayTitle.text = "Day ".localized() + String(daySelected + 1)
            myTripView.activitiesTableView.reloadData()
            return newActivities
        }
        return []
    }
    
    func emptyState(activities: [ActivityLocal]) {
        if activities.isEmpty {
            myTripView.activitiesTableView.isHidden = true
            myTripView.budgetView.isHidden = true
            myTripView.emptyStateTitle.isHidden = false
            myTripView.emptyStateImage.isHidden = false
            myTripView.scrollView.isScrollEnabled = false
        } else {
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
        let user = UserRepository.shared.getUser()
        if !user.isEmpty {
            let introduction = "Hey! Join my roadmap in Wimbi app using the code: " + (roadmap.shareKey ?? "0")
            let activityItem = MyActivityItemSource(title: "Share your code roadmap!", text: introduction)
            
            let activityViewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = []
            self.roadmap.isShared = true
            RoadmapRepository.shared.saveContext()
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    func updateAllBudget() {
        Task {
            var budgetDay = 0.0
            await budgetDay = currencyController.updateBudget(activites: activites, userCurrency: self.userCurrency)
            myTripView.budgetValue.text = "\(userCurrency) \(budgetDay)"
            await budgetTotal = currencyController.updateBudgetTotal(userCurrency: self.userCurrency, days: days)
            roadmap.budget = budgetTotal
            RoadmapRepository.shared.saveContext()
            self.updateTotalBudgetValue()
        }
    }
    func updateTotalBudgetValue() {
        guard let cell = myTripView.infoTripCollectionView.cellForItem(at: [0, 1]) as? InfoTripCollectionViewCell else { return }
        cell.infoTitle.text = "\(self.userCurrency)\(self.budgetTotal)"
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
}
