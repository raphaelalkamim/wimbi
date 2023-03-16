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
        let addRoadMap = UIAction(title: "New itinerary".localized(), image: UIImage(systemName: "pencil")) { _ in
            self.addNewRoadmap()
        }
        
        let insertRoadMap = UIAction(title: "Join itinerary".localized(), image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis")) { _ in
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
        
        let titleFont = UIFont(name: "Avenir-Black", size: 18)!
        let titleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: titleFont)]
        let stringTitle = NSAttributedString(string: "Join itinerary".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(stringTitle, forKey: "attributedTitle")
        
        let subtitleFont = UIFont(name: "Avenir-Roman", size: 14)!
        let subtitleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .footnote).scaledFont(for: subtitleFont)]
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
