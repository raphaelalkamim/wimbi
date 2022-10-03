//
//  LoginViewController.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 14/09/22.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, UserLoggedInDelegate {
    let loginView = LoginView()
    weak var coordinatorExplore: ExploreCoordinator?
    weak var coordinatorProfile: ProfileCoordinator?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        DataManager.shared.delegate = self
        
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelCreation))
        cancelButton.tintColor = .systemRed
        self.navigationItem.leftBarButtonItem = cancelButton
        
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            print(userID)
            print(UserDefaults.standard.string(forKey: "authorization"))
        }
    }
    
    @objc func cancelCreation() {
        if let coordinatorExplore = coordinatorExplore {
            coordinatorExplore.back()
        } else {
            coordinatorProfile?.backPage()
        }
    }
    
    func finishLogin() {
        if let coordinatorExplore = coordinatorExplore {
            coordinatorExplore.createNewRoadmap()
        } else {
            coordinatorProfile?.backPage()
        }
    }
}

protocol UserLoggedInDelegate: AnyObject {
    func finishLogin()
}
