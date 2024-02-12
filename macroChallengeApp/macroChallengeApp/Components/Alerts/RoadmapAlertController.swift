//
//  RoadmapAlertController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 12/02/24.
//

import UIKit

class RoadmapAlertController: UIAlertController {
    static func cantDelete(handler: ()) -> UIAlertController {
        let action = UIAlertController(title: "Can't delete", message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            handler
        }))
        return action
    }
    
    static func deleteRoadmap(roadmap: RoadmapDTO, handler: ()) -> UIAlertController {
        let action = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        action.setValue(self.getAlertTitle(roadmapName: roadmap.name), forKey: "attributedTitle")
        action.setValue(self.getAlertSubtitle(), forKey: "attributedMessage")
        action.addAction(UIAlertAction(title: "Delete".localized(), style: .destructive, handler: { _ in
            do {
                try RoadmapRepository.shared.deleteRoadmap(roadmap: roadmap)
            } catch { print(error) }
        }))
        action.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        action.view.tintColor = .accent
        return action
    }
    
    static func roadmapsHasBeenDeleted() -> UIAlertController {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleFont = UIFont(name: "Avenir-Black", size: 18)!
        let titleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: titleFont)]
        let string = NSAttributedString(string: "This itinerary has been deleted by another user".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(string, forKey: "attributedMessage")

        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
        }))
        
        return alert
    }
    
    static func getAlertTitle(roadmapName: String) -> NSAttributedString {
        let roadmapName = "'\(roadmapName)'"
        let titleFont = UIFont(name: "Avenir-Black", size: 16)!
        let titleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: titleFont)]
        let title = "Delete all content from".localized()
        let string = NSAttributedString(string: "\(title) \(roadmapName)", attributes: titleAtt as [NSAttributedString.Key: Any])
        return string
    }
    
    static func getAlertSubtitle() -> NSAttributedString {
        let subtitleFont = UIFont(name: "Avenir-Roman", size: 16)!
        let subtitleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: subtitleFont)]
        let subtitleString = NSAttributedString(string: "The content cannot be recovered.".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        return subtitleString
    }
}
