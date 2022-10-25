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
    
    var roadmap = RoadmapLocal()
    var activites: [ActivityLocal] = []
    var days: [DayLocal] = []
    var daySelected = 0
    var budgetTotal: Double = 0
    
    lazy var userCurrency: String = {
        let userC = self.getUserCurrency()
        return userC
    }()
    
    override func viewDidLoad() {
        network.startMonitoring()
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupMyTripView()
        myTripView.setupContent(roadmap: roadmap)
        myTripView.bindCollectionView(delegate: self, dataSource: self)
        myTripView.bindTableView(delegate: self, dataSource: self, dragDelegate: self)
        myTripView.addButton.addTarget(self, action: #selector(goToCreateActivity), for: .touchUpInside)
        
        myTripView.activitiesTableView.reloadData()
        myTripView.activitiesTableView.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateByBack(roadmap: self.roadmap, isShared: true)
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
    
    func getCurrencyFromAPI(userCurrency: String, outgoinCurrency: String) async -> Double {
        var total: Double = 0
        let currency = await CurrencyAPI.shared.getCurrency(incomingCurrency: userCurrency, outgoingCurrency: outgoinCurrency)
        
        if let currency = currency {
            let value = currency.array[0].high
            let currencyToDouble = Double(value) ?? 0
            total = currencyToDouble
        }
        return total
    }
    
    func getUserCurrency() -> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        if currencySymbol == "$" {
            return "U$"
        } else {
            return currencySymbol ?? "U$"
        }
    }
    
    func updateByBack(roadmap: RoadmapLocal, isShared: Bool) {
        if self.roadmap.isShared {
            // chama o roadmap do back
            DataManager.shared.getRoadmapById(roadmapId: Int(roadmap.id)) { backRoadmap in
                print(backRoadmap.days[0].activity)
                print(backRoadmap.days[1].activity)
                self.roadmap = RoadmapRepository.shared.updateByBackend(editRoadmap: self.roadmap, roadmap: backRoadmap, isShared: false)
            }
        }
    }
    func updateAllBudget() {
        Task {
            await self.updateBudget()
            await self.updateBudgetTotal()
            await self.updateTotalBudgetValue()
        }
    }
    func updateBudget() async {
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
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "U$":
                totalDollar += activite.budget
                if userCurrency == "U$" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "€":
                totalEuro += activite.budget
                if userCurrency == "€" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "¥":
                totalYen += activite.budget
                if userCurrency == "¥" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "Fr":
                totalSwiss += activite.budget
                if userCurrency == "Fr" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            case "元":
                totalRenminbi += activite.budget
                if userCurrency == "元" {
                    budgetDay += activite.budget
                } else {
                    let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                    budgetDay += activite.budget * value
                }
                
            default:
                break
            }
        }
        myTripView.budgetValue.text = "\(userCurrency) \(budgetDay)"
    }
    
    func updateBudgetTotal() async {
        budgetTotal = 0
        for day in days {
            for activite in day.activity?.allObjects as [ActivityLocal] {
                switch activite.currencyType {
                case "R$":
                    if userCurrency == "R$" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "U$":
                    if userCurrency == "U$" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "€":
                    if userCurrency == "€" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "¥":
                    if userCurrency == "¥" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "Fr":
                    if userCurrency == "Fr" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                case "元":
                    if userCurrency == "元" {
                        budgetTotal += activite.budget
                    } else {
                        let value = await getCurrencyFromAPI(userCurrency: userCurrency, outgoinCurrency: activite.currencyType ?? "R$")
                        budgetTotal += activite.budget * value
                    }
                    
                default:
                    break
                }
            }
        }
        roadmap.budget = budgetTotal
        RoadmapRepository.shared.saveContext()
    }
    
    func updateTotalBudgetValue() {
        guard let cell = myTripView.infoTripCollectionView.cellForItem(at: [0, 1]) as? InfoTripCollectionViewCell else { return }
        cell.infoTitle.text = "\(self.userCurrency)\(self.budgetTotal)"
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
}

extension MyTripViewController: ReviewTravelDelegate {
    func updateRoadmapScreen(roadmap: RoadmapLocal) {
        self.roadmap = roadmap
        self.getAllDays()
        self.activites = self.getAllActivities()
        self.emptyState(activities: activites)
        Task {
            await self.updateBudget()
        }
        self.updateTotalBudgetValue()
        
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 2)])
        myTripView.calendarCollectionView.reloadData()
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
    }
}
