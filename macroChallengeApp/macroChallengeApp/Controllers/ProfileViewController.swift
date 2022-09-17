//
//  ProfileViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

class ProfileViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupProfileView()
        
        profileView.bindColletionView(delegate: self, dataSource: self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileSettings))
        
        profileView.addButton.addTarget(self, action: #selector(addAction), for: .touchDown)

    }
    
    @objc func profileSettings() {
        coordinator?.settings()
    }
    
    @objc func addAction() {
        coordinator?.newRoadmap()
    }
}
