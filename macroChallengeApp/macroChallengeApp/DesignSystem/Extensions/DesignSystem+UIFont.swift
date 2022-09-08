//
//  DesignSystem+UIFont.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 08/09/22.
//

import Foundation
import UIKit

extension UIFont {
    static var body: UIFont {
        UIFont(name: "Avenir-Roman", size: 17)!
    }
    
    static var title: UIFont {
        UIFont(name: "Avenir-Black", size: 24)!
    }
    
    static var largeTitle: UIFont {
        UIFont(name: "Avenir-Black", size: 34)!
    }
    
    static var caption: UIFont {
        UIFont(name: "Avenir-Roman", size: 14)!
    }
}
