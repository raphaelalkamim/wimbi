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
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let myTripView = MyTripView()
    
    var roadmap = RoadmapLocal()
    var activites: [ActivityLocal] = []
    var days: [DayLocal] = []
    
    var daySelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupMyTripView()
        
        myTripView.setupContent(roadmap: roadmap)
        myTripView.bindCollectionView(delegate: self, dataSource: self)
        myTripView.bindTableView(delegate: self, dataSource: self, dragDelegate: self)
        myTripView.addButton.addTarget(self, action: #selector(goToCreateActivity), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllDays()
        self.activites = self.getAllActivities()
    }
    func updateBudget() {
        var budgetDay: Double = 0
        for activite in activites {
            budgetDay += activite.budget
        }
        guard let cell = myTripView.infoTripCollectionView.cellForItem(at: [0, 1]) as? InfoTripCollectionViewCell else { return }
        cell.title.text = "R$\(budgetDay)"
        myTripView.budgetValue.text = "R$\(budgetDay)"
    }
    func getAllDays() {
        if var newDays = roadmap.day?.allObjects as? [DayLocal] {
            newDays.sort { $0.id < $1.id }
            self.days = newDays
            print(days)
        }
        for index in 0..<days.count where days[index].isSelected == true {
            self.daySelected = index
            myTripView.dayTitle.text = "Dia " + String(daySelected + 1)
        }
    }
    
    func getAllActivities() -> [ActivityLocal] {
        if var newActivities = days[daySelected].activity?.allObjects as? [ActivityLocal] {
            newActivities.sort { $0.hour ?? "1" < $1.hour ?? "2" }
            return newActivities
        }
        self.updateBudget()
        return []
    }
    
    @objc func goToCreateActivity() {
        coordinator?.startActivity(day: self.days[daySelected], delegate: self)
    }
}
