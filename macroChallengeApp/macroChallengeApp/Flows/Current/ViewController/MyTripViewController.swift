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
    var activites: [Activity] = [Activity(id: 1, name: "Comer", category: "Comida", location: "fdsa", hour: "8:00", budget: 123, day: Day()),
                                 Activity(id: 2, name: "Chorar", category: "Comida", location: "fdsa", hour: "10:00", budget: 123, day: Day()),
                                 Activity(id: 3, name: "Dormir", category: "Comida", location: "fdsa", hour: "12:00", budget: 123, day: Day()),
                                 Activity(id: 4, name: "Respirar", category: "Comida", location: "fdsa", hour: "14:00", budget: 123, day: Day())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupMyTripView()
        myTripView.bindCollectionView(delegate: self, dataSource: self)
        myTripView.bindTableView(delegate: self, dataSource: self, dragDelegate: self)
        myTripView.addButton.addTarget(self, action: #selector(goToCreateActivity), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var budgetDay: Double = 0
        for activite in activites {
            budgetDay += activite.budget
        }
        
        myTripView.budgetValue.text = "R$\(budgetDay)"
    }

    @objc func goToCreateActivity() {
        coordinator?.startActivity()
    }
}
