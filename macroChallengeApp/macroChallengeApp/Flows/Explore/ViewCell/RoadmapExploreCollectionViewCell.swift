//
//  RoadmapExploreCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 23/09/22.
//

import Foundation
import UIKit

class RoadmapExploreCollectionViewCell: UICollectionViewCell {
    static let identifier = "exploreCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var cover: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var travellers: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var days: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var costByPerson: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var heart: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var totalLikes: UILabel = {
        let label = UILabel()
        return label
    }()
    
}

extension RoadmapExploreCollectionViewCell {
    func setup() {
        
    }
    
    func setupConstraints() {
        
    }
}
