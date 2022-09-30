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
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewController = EditProfileViewController()
            viewController.navigationItem.title = "Edit profile".localized()
            navigationController?.pushViewController(viewController, animated: true)
            
        case 1:
            let viewController = LikedRoadmapsViewController()
            viewController.navigationItem.title = "Liked roadmaps".localized()
            navigationController?.pushViewController(viewController, animated: true)
            
        case 2:
            let viewController = NotificationsViewController()
            viewController.navigationItem.title = "Notifications".localized()
            navigationController?.pushViewController(viewController, animated: true)
        case 3:
            let viewController = TermsViewController()
            viewController.navigationItem.title = "Privacy policies".localized()
            navigationController?.pushViewController(viewController, animated: true)
            
        case 4:
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.view.tintColor = .accent
            let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 17)]
            let string = NSAttributedString(string: "Sign out of your account?".localized(), attributes: titleAtt)
            alert.setValue(string, forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            }))
            alert.addAction(UIAlertAction(title: "Sign out".localized(), style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                // Ação Cancelar
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
            cell.title.text = "Privacy policies".localized()
            cell.icon.setImage(UIImage(systemName: "book.closed.fill"), for: .normal)
            
        case 4:
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
