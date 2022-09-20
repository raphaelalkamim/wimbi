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
    
    // Utilizada nas células da tela de Perfil
    static var cellTitle: UIFont {
        UIFont(name: "Avenir-Medium", size: 18)!
    }
    
    static var title: UIFont {
        UIFont(name: "Avenir-Black", size: 24)!
    }
    
    static var mediumTitle: UIFont {
        UIFont(name: "Avenir-Black", size: 30)!
    }
    
    static var largeTitle: UIFont {
        UIFont(name: "Avenir-Black", size: 34)!
    }
    
    static var caption: UIFont {
        UIFont(name: "Avenir-Roman", size: 14)!
    }
    
    static var smallCaption: UIFont {
        UIFont(name: "Avenir-Roman", size: 12)!
    }
}
