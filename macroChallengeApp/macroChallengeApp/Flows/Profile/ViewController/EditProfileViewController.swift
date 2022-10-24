//
//  EditProfileViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import SnapKit

class EditProfileViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let editProfileView = EditProfileView()
    var user: User?
    let network: NetworkMonitor = NetworkMonitor.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.startMonitoring()
        self.view.backgroundColor = .backgroundPrimary
        self.setupEditProfileView()
        
        if let data = UserDefaults.standard.data(forKey: "user") {
            do {
                let decoder = JSONDecoder()
                self.user = try decoder.decode(User.self, from: data)
                if let user = self.user {
                    self.changeToUserInfo(user: user)
                }
                
            } catch {
                print("Unable to decode")
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized(), style: .plain, target: self, action: #selector(saveProfile))
    }
    
    @objc func saveProfile() {
        network.startMonitoring()
        if !network.isReachable {
            let action = UIAlertController(title: "You are offiline. Can't save", message: nil, preferredStyle: .actionSheet)
            action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [] _ in
            }))
            present(action, animated: true)
        } else {
            if let newName = editProfileView.nameTextField.text, let newUsernameApp = editProfileView.usernameTextField.text {
                self.user?.name = newName
                self.user?.usernameApp = newUsernameApp
                if let user = user {
                    DataManager.shared.putUser(userObj: user) { user in
                        do {
                            let encoder = JSONEncoder()

                            let data = try encoder.encode(user)

                            UserDefaults.standard.set(data, forKey: "user")
                        } catch {
                            print("Unable to Encode")
                        }
                    }
                }
            }
            coordinator?.backPage()
        }
    }
    
    func changeToUserInfo(user: User) {
        self.editProfileView.imageProfile.image = UIImage(named: "icon")
        self.editProfileView.nameTextField.text = user.name
        self.editProfileView.usernameTextField.text = user.usernameApp
    }
}

extension EditProfileViewController {
    func setupEditProfileView() {
        view.addSubview(editProfileView)
        setupConstraints()
    }
    func setupConstraints() {
        editProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
