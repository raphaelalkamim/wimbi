//
//  UILabel+Font.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 08/09/22.
//

import Foundation
import UIKit

extension UILabel {
    func stylize(with textStyle: TextStyle) {
        self.font = textStyle.font
        self.textColor = textStyle.color
        self.textAlignment = textStyle.alignment
        
        if let textStyle = textStyle as? CustomLabelDesignable {
            textStyle.custom(self)
        }
        
        self.adjustsFontForContentSizeCategory = true
    }
}
