//
//  EditProfileViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 19/09/22.
//

import Foundation
import UIKit

class NotificationsViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let notificationsView = NotificationsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupNotificationsView()
        notificationsView.bindTableView(delegate: self, dataSource: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized(), style: .plain, target: self, action: #selector(savePicker))
    }
    
    @objc func savePicker() {
        let table = notificationsView.notificationsTableView
        let cellSwitch = table.cellForRow(at: [0, 1]) as? NotificationPickerTableViewCell
        coordinator?.backPage()
        UserDefaults.standard.set(cellSwitch?.picker.selectedRow(inComponent: 0), forKey: "number")
        UserDefaults.standard.set(cellSwitch?.picker.selectedRow(inComponent: 1), forKey: "interval")

    }
}
