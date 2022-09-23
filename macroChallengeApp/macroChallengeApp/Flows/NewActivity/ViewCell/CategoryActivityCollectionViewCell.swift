//
//  StackTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 15/09/22.
//

import Foundation
import UIKit
import SnapKit

class CategoryActivityCollectionViewCell: UICollectionViewCell {
    static let identifier = "categoryActivityCell"
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "categoryBeach")
        return icon
    }()

    lazy var iconDescription: UILabel = {
        let description = UILabel()
        description.text = "oi"
        description.stylize(with: designSystem.text.smallCaption)
        return description
    }()
    
}

extension CategoryActivityCollectionViewCell {
    func setup() {
        self.backgroundColor = .clear
        contentView.addSubview(icon)
        contentView.addSubview(iconDescription)
        setupConstraints()
    }
    
    func setupConstraints() {
        icon.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(designSystem.spacing.mediumPositive)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
            
        }
        iconDescription.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.centerX.equalTo(icon.snp.centerX)
        }
    }
    
    func selectedBackgroundView() {
        icon.layer.borderWidth = 1.5
        icon.layer.borderColor = designSystem.palette.caption.cgColor
    }
    
    func notSelectedBackgroundView() {
        icon.layer.borderWidth = 0
        
    }
}
