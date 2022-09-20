//
//  LoginViewController.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 14/09/22.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate {
    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            print(userID)
            print(UserDefaults.standard.string(forKey: "authorization"))
        }
    }
}
