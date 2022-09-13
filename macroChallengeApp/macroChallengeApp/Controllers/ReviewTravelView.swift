//
//  ReviewTravelViewController.swift
//  macroChallengeApp
//
//  Created by Juliana Santana on 13/09/22.
//

import Foundation

class ReviewTravelView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    private lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var categoryImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.stylize(with: designSystem.text.largeTitle)
        return title
    }()
    
    private lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.stylize(with: designSystem.text.caption)
        return subtitle
    }()
    
}
