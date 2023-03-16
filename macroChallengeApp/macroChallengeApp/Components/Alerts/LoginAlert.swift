//
//  LoginAlert.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 09/12/22.
//

import Foundation
import UIKit

class LoginAlert: UIAlertController {
    init(controller: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleFont = UIFont(name: "Avenir-Black", size: 18)!
        let titleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: titleFont)]
        let string = NSAttributedString(string: "Login required".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(string, forKey: "attributedTitle")
        let subtitleFont = UIFont(name: "Avenir-Roman", size: 14)!
        let subtitleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .footnote).scaledFont(for: subtitleFont)]
        let subtitleString = NSAttributedString(string: "Access the profile and log-in to duplicate or create new itineraries".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        controller.present(alert, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
