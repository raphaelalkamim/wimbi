//
//  ProfileViewController+ContextMenu.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 28/09/22.
//

import Foundation
import UIKit

extension ProfileViewController {
    func setContextMenu() {
        let addRoadMap = UIAction(title: "New trip".localized(), image: UIImage(systemName: "pencil")) { _ in
            self.coordinator?.newRoadmap()
        }
        
        let insertRoadMap = UIAction(title: "Join trip".localized(), image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis")) { _ in
            self.setUIAlert()
        }
        
        profileView.addButton.showsMenuAsPrimaryAction = true
        profileView.addButton.menu = UIMenu(title: "", children: [addRoadMap])
    }
    
    func setUIAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let stringTitle = NSAttributedString(string: "Join trip".localized(), attributes: titleAtt)
        alert.setValue(stringTitle, forKey: "attributedTitle")
        
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let stringSub = NSAttributedString(string: "Add the code to have access to the trip".localized(), attributes: subtitleAtt)
        alert.setValue(stringSub, forKey: "attributedMessage")
        
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Join".localized(), style: .default) { _ in
            print(textField.text ?? "Error")
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .destructive) { _ in
            print("Cancel")
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
