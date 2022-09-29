//
//  ExploreViewController+ContextMenu.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 28/09/22.
//

import Foundation
import UIKit

extension ExploreViewController {
func setContextMenu() {
        let addRoadMap = UIAction(title: "New trip", image: UIImage(systemName: "pencil")) { _ in
            self.addNewRoadmap()
        }
        
        let insertRoadMap = UIAction(title: "Existing trip", image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis")) { _ in
            self.setUIAlert()
        }
        
        let menuBarButton = UIBarButtonItem(
            title: "Add",
            image: UIImage(systemName: "plus"),
            primaryAction: nil,
            menu: UIMenu(title: "", children: [addRoadMap, insertRoadMap])
        )
        
        self.navigationItem.rightBarButtonItem = menuBarButton
    }

    func setUIAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let stringTitle = NSAttributedString(string: "Join in a trip", attributes: titleAtt)
        alert.setValue(stringTitle, forKey: "attributedTitle")
        
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let stringSub = NSAttributedString(string: "Add the code to have access to the trip", attributes: subtitleAtt)
        alert.setValue(stringSub, forKey: "attributedMessage")
        
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Join", style: .default) { _ in
            print(textField.text ?? "Error")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            print("Cancel")
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

}
