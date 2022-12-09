//
//  DuplicateAlert.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 09/12/22.
//

import Foundation
import UIKit

class DuplicateAlert: UIAlertController {
    init(controller: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let string = NSAttributedString(string: "Successfully duplicated!".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(string, forKey: "attributedTitle")
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let subtitleString = NSAttributedString(string: "The itinerary is now available on your profile.".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        controller.present(alert, animated: true)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
