//
//  DefaultDesignFonts.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 08/09/22.
//

import Foundation
import UIKit

struct XxxLargeTitleTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .largeTitle
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .xLargeTitle
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct XxLargeTitleTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .largeTitle
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .xLargeTitle
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct XLargeTitleTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .largeTitle
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .xLargeTitle
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct LargeTitleTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .largeTitle
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .largeTitle
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct MediumTitleTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .title1
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .mediumTitle
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct TitleTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .title2
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .title
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct SmallTitleTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .title3
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .smallTitle
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct HeadlineTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .headline
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .headline
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct BodyTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .body
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .body

    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct SubheadlineTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .subheadline
    var color: UIColor = .textPrimary
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .subheadline

    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct FootnoteTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .subheadline
    var color: UIColor = .caption
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .footnote
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct CaptionTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .caption1
    var color: UIColor = .caption
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .caption
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct SmallCaptionTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .caption2
    var color: UIColor = .caption
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .smallCaption
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}

struct XSmallCaptionTextStyle: TextStyle, CustomLabelDesignable {
    var style: UIFont.TextStyle = .caption2
    var color: UIColor = .caption
    var alignment: NSTextAlignment = .natural
    var font: UIFont = .xSmallCaption
    
    func custom(_ label: UILabel) {
        label.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
    }
}
