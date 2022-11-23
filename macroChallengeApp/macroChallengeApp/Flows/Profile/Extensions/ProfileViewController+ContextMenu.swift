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
        let addRoadMap = UIAction(title: "New itinerary".localized(), image: UIImage(systemName: "pencil")) { _ in
            self.coordinator?.newRoadmap()
        }
        
        let insertRoadMap = UIAction(title: "Join itinerary".localized(), image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis")) { _ in
            self.setUIAlert()
        }
        
        profileView.addButton.showsMenuAsPrimaryAction = true
        profileView.addButton.menu = UIMenu(title: "", children: [addRoadMap, insertRoadMap])
    }
    
    func setUIAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let stringTitle = NSAttributedString(string: "Join itinerary".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(stringTitle, forKey: "attributedTitle")
        
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let stringSub = NSAttributedString(string: "Add a trip code that a friend shared with you to have access to the itinerary".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        alert.setValue(stringSub, forKey: "attributedMessage")
        
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .destructive) { _ in
            print("Cancel")
        }
        
        let action = UIAlertAction(title: "Join".localized(), style: .default) { _ in
            print(textField.text ?? "Error")
            if let roadmapKey = textField.text {
                DataManager.shared.joinRoadmap(roadmapKey: roadmapKey)
            }
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
