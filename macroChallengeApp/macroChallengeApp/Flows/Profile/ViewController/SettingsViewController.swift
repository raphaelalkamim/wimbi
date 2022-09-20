//
//  SettingsViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 17/09/22.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let settingsView = SettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupSettingsView()
        settingsView.bindTableView(delegate: self, dataSource: self)
    }
}
