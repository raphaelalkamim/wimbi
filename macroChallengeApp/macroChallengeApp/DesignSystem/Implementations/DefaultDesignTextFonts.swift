//
//  DefaultDesignFonts.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 08/09/22.
//

import Foundation
import UIKit

struct BodyTextStyle: TextStyle, CustomLabelDesignable {
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .body
    
    func custom(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct CellTitleTextStyle: TextStyle, CustomLabelDesignable {
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .cellTitle
    
    func custom(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct TitleTextStyle: TextStyle, CustomLabelDesignable {
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .title
    
    func custom(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct MediumTitleTextStyle: TextStyle, CustomLabelDesignable {
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .mediumTitle
    
    func custom(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct LargeTitleTextStyle: TextStyle, CustomLabelDesignable {
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .largeTitle
    
    func custom(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct CaptionTextStyle: TextStyle, CustomLabelDesignable {
    var color: UIColor = .caption
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .caption
    
    func custom(_ label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}
