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
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupProfileView()
        
        profileView.bindColletionView(delegate: self, dataSource: self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileSettings))
        
        profileView.addButton.addTarget(self, action: #selector(addAction), for: .touchDown)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            DataManager.shared.getUser(username: userID, { user in
                self.user = user
                self.profileView.getTitle().text = user.name
                self.profileView.getUsernameApp().text = "@\(user.usernameApp)"
                self.profileView.getTable().reloadData()
            })
        }
    }
    
    @objc func profileSettings() {
        coordinator?.settings()
    }
    
    @objc func addAction() {
        coordinator?.newRoadmap()
    }
}
