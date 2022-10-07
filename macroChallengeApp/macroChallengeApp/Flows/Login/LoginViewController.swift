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
        
        navigationItem.hidesBackButton = true
        if coordinatorExplore != nil {
            let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelCreation))
            cancelButton.tintColor = .accent
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let coordinatorProfile = coordinatorProfile, UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            coordinatorProfile.backPage()
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
            coordinatorExplore.back()
            coordinatorExplore.createNewRoadmap()
        } else {
            coordinatorProfile?.backPage()
        }
        
    }
}

protocol UserLoggedInDelegate: AnyObject {
    func finishLogin()
}
