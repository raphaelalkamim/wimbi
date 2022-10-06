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
        self.emptyState(activities: activites)
        self.updateBudget()
        self.updateTotalBudgetValue()
    }
    
    func getAllDays() {
        if var newDays = roadmap.day?.allObjects as? [DayLocal] {
            newDays.sort { $0.id < $1.id }
            self.days = newDays
        }
        for index in 0..<days.count where days[index].isSelected == true {
            self.daySelected = index
            myTripView.dayTitle.text = "Dia " + String(daySelected + 1)
        }
    }
    
    func getAllActivities() -> [ActivityLocal] {
        if var newActivities = days[daySelected].activity?.allObjects as? [ActivityLocal] {
            newActivities.sort { $0.hour ?? "1" < $1.hour ?? "2" }
            myTripView.dayTitle.text = "Dia " + String(daySelected + 1)
            myTripView.activitiesTableView.reloadData()
            return newActivities
        }
        return []
    }
    
    func getCurrencyFromAPI(userCurrency: String, outgoinCurrency: String) -> Double {
        CurrencyAPI.shared.getCurrency(incomingCurrency: userCurrency, outgoingCurrency: outgoinCurrency) { currency in
        print(currency.high)
        print(currency.name)
    }
        
        let currencyValue = CurrencyAPI.shared.currency?.high ?? ""
        return Double(currencyValue) ?? 0
    }
    
    
    func updateBudget() {
        let userCurrency = "R$"
        var budgetDay: Double = 0
        
        var totalReal: Double = 0
        var totalDollar: Double = 0
        var totalEuro: Double = 0
        var totalYen: Double = 0
        var totalSwiss: Double = 0
        var totalRenminbi: Double = 0
        
        for activite in activites {
            switch activite.currencyType {
            case "R$":
                totalReal += activite.budget
                if userCurrency == "R$" {
                    budgetDay += activite.budget
                } else {
                    budgetDay += activite.budget * getCurrencyFromAPI( userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                }
                
            case "U$":
                totalDollar += activite.budget
                if userCurrency == "U$" {
                    budgetDay += activite.budget
                } else {
                    budgetDay += activite.budget * getCurrencyFromAPI( userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                }
                
            case "€":
                totalEuro += activite.budget
                if userCurrency == "€" {
                    budgetDay += activite.budget
                } else {
                    budgetDay += activite.budget * getCurrencyFromAPI( userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                }
                
            case "¥":
                totalYen += activite.budget
                if userCurrency == "¥" {
                    budgetDay += activite.budget
                } else {
                    budgetDay += activite.budget * getCurrencyFromAPI( userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                }
                
            case "Fr":
                totalSwiss += activite.budget
                if userCurrency == "Fr" {
                    budgetDay += activite.budget
                } else {
                    budgetDay += activite.budget * getCurrencyFromAPI( userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                }
                
            case "元":
                totalRenminbi += activite.budget
                if userCurrency == "元" {
                    budgetDay += activite.budget
                } else {
                    budgetDay += activite.budget * getCurrencyFromAPI( userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                }
                
            default:
                break
            }
            print(totalReal)
            print(totalDollar)
            print(totalEuro)
            print(totalYen)
            print(totalSwiss)
            print(totalRenminbi)
        }
        myTripView.budgetValue.text = "\(userCurrency) \(budgetDay)"
    }
    
    func updateTotalBudgetValue() {
        guard let cell = myTripView.infoTripCollectionView.cellForItem(at: [0, 1]) as? InfoTripCollectionViewCell else { return }
        cell.infoTitle.text = "R$\(self.roadmap.budget)"
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
}

extension Sequence {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}

extension MyTripViewController: ReviewTravelDelegate {
    func updateRoadmapScreen(roadmap: RoadmapLocal) {
        self.roadmap = roadmap
        self.getAllDays()
        self.activites = self.getAllActivities()
        self.emptyState(activities: activites)
        self.updateBudget()
        self.updateTotalBudgetValue()
        
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 2)])
        myTripView.calendarCollectionView.reloadData()
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
    }
}
