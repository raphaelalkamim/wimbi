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
    var currencyType: String = "R$" {
        didSet {
            newActivityView.valueTable.reloadData()
        }
    }
    var fonts: [UIFont]! {
        didSet {
            // tableView.reloadData()
        }
    }
    var activity: Activity = Activity(id: 0, name: "", category: "", location: "", hour: "", budget: 0, day: Day(isSelected: true, date: Date()))
    
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
        print(activity.name)
    }
    
    @objc func cancelCreation() {
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
    }
    
    @objc func saveActivity() {
        self.setData()
        var createdActivity: ActivityLocal?
        if edit {
            ActivityRepository.shared.updateActivity(day: self.day, oldActivity: self.activityEdit, activity: self.activity)
            do {
                try ActivityRepository.shared.deleteActivity(activity: self.activityEdit, roadmap: self.roadmap)
            } catch {
                "erro ao deletar atividade"
            }
        } else {
            createdActivity = ActivityRepository.shared.createActivity(day: self.day, activity: self.activity)
        }
        self.delegate?.attTable()
        coordinator?.backPage()
        coordinatorCurrent?.backPage()
        
        if UserDefaults.standard.bool(forKey: "switch") == true {
            print("registrou")
            if let safeActivity = createdActivity {
                NotificationManager.shared.registerNotification(createdActivity: safeActivity)
            }
            
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
