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
    weak var delegate: SignOutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupSettingsView()
        let helpButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(info))
        self.navigationItem.rightBarButtonItem = helpButton
        settingsView.bindTableView(delegate: self, dataSource: self)
    }
    
    @objc func info() {
        coordinator?.startOnboarding()
    }
}
