//
//  NewActivityViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 14/09/22.
//

import Foundation
import UIKit
import MapKit
import UserNotifications

class NewActivityViewController: UIViewController {
    weak var delegate: AddNewActivityDelegate?
    weak var coordinator: ProfileCoordinator?
    weak var coordinatorCurrent: CurrentCoordinator?
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let newActivityView = NewActivityView()
    
    lazy var userCurrency: String = {
        let userC = self.getUserCurrency()
        return userC
    }()
    
    var currencyType: String = "U$" {
        didSet {
            newActivityView.valueTable.reloadData()
        }
    }
    var fonts: [UIFont]! {
        didSet {
            // tableView.reloadData()
        }
    }
    var activity: Activity = Activity(id: 0, name: "New Activity", category: "empty", location: "", hour: "", budget: 0, currencyType: "", tips: "", day: Day(isSelected: true, date: Date()))
    
    var day = DayLocal()
    var local: String = ""
    var address: String = ""
    var roadmap = RoadmapLocal()
    var activityEdit = ActivityLocal()
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewActivityView()
        setKeyboard()
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelCreation))
        cancelButton.tintColor = .accent
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let salvarButton = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(saveActivity))
        self.navigationItem.rightBarButtonItem = salvarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if edit {
            getData()
        }
        if !edit {
            self.currencyType = userCurrency
        }
    }
    
    @objc func cancelCreation() {
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
    }
    
    @objc func saveActivity() {
        self.setData()
        var createdActivity: ActivityLocal?
        if edit {
            self.activity.id = Int(self.activityEdit.id)
            ActivityRepository.shared.updateActivity(day: self.day, oldActivity: self.activityEdit, activity: self.activity)
        } else {
            createdActivity = ActivityRepository.shared.createActivity(day: self.day, activity: self.activity)
        }
        self.delegate?.attTable()
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
        print(activity)
        
        if UserDefaults.standard.bool(forKey: "switch") == true {
            if let safeActivity = createdActivity {
                NotificationManager.shared.registerActivityNotification(createdActivity: safeActivity)

            }
        }
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
}

// MARK: Keyboard extension
extension NewActivityViewController {
    fileprivate func setKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissMissKeyboard))
        
        newActivityView.valueTable.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            newActivityView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            newActivityView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardSize.height, right: 0)}
    }
    
    @objc func dissMissKeyboard() {
        view.endEditing(true)
    }
}
