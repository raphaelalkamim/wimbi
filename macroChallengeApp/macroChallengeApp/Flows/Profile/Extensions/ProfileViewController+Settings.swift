//
//  ProfileViewController+Settings.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 17/09/22.
//

import Foundation
import UIKit

extension SettingsViewController {
    func setupSettingsView() {
        view.addSubview(settingsView)
        setupConstraints()
    }
    func setupConstraints() {
        settingsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            coordinator?.startEditProfile()
            
        case 1:
            coordinator?.startLikedRoadmaps()
            
        case 2:
            coordinator?.startNotifications()

        case 3:
            coordinator?.startTerms()
            
        case 4:
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.view.tintColor = .accent
            let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 17)]
            let string = NSAttributedString(string: "Delete your account?".localized(), attributes: titleAtt)
            alert.setValue(string, forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            }))
            
            alert.addAction(UIAlertAction(title: "Delete".localized(), style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
                    let userID = String(data: data, encoding: .utf8)!
                    DataManager.shared.deleteObjectBack(username: userID, urlPrefix: "users")
                }
                KeychainManager.shared.delete(service: "username", account: "explorer")
                SignInWithAppleManager.shared.revokeToken()
                UserDefaults.standard.setValue("", forKey: "authorization")
                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(nil, forKey: "user")
                let userActual = UserRepository.shared.getUser()
                do {
                    try UserRepository.shared.deleteUser(user: userActual[0])
                } catch {
                    print(error)
                }
                KeychainManager.shared.delete(service: "signInRefresh", account: "explorer")
                self.coordinator?.backPage()
            }))
            present(alert, animated: true)
        
        case 5:
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.view.tintColor = .accent
            let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 17)]
            let string = NSAttributedString(string: "Sign out of your account?".localized(), attributes: titleAtt)
            alert.setValue(string, forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            }))
            
            alert.addAction(UIAlertAction(title: "Sign out".localized(), style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                KeychainManager.shared.delete(service: "username", account: "explorer")
                UserDefaults.standard.setValue("", forKey: "authorization")
                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(nil, forKey: "user")
                
                self.coordinator?.backPage()
            }))
            present(alert, animated: true)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            preconditionFailure("Cell not find")
        }
        cell.setup()
        cell.backgroundColor = designSystem.palette.backgroundCell
        
        switch indexPath.row {
        case 0:
            cell.title.text = "Edit profile".localized()
            cell.icon.setImage(UIImage(systemName: "person.fill"), for: .normal)
            
        case 1:
            cell.title.text = "Liked roadmaps".localized()
            cell.icon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        case 2:
            cell.title.text = "Notifications".localized()
            cell.icon.setImage(UIImage(systemName: "bell.fill"), for: .normal)
            
        case 3:
            cell.title.text = "Privacy Policies".localized()
            cell.icon.setImage(UIImage(systemName: "book.closed.fill"), for: .normal)
            
        case 4:
            cell.title.text = "Delete account".localized()
            cell.title.textColor = .redCity
            cell.icon.isHidden = true
            cell.chevron.isHidden = true
            cell.title.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(designSystem.spacing.largePositive)
            }
            
        case 5:
            cell.title.text = "Sign out".localized()
            cell.title.textColor = .redCity
            cell.icon.isHidden = true
            cell.chevron.isHidden = true
            cell.title.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(designSystem.spacing.largePositive)
            }

        default:
            break
        }
        
        return cell
        
    }
    
}
