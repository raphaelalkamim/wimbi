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
    
    func setCellIcon(isSelected: Bool) -> String {
        var buttonType = ""
        switch self.iconDescription.text {
        case "Accommodation".localized():
            buttonType = "accommodation"
        case "Food".localized():
            buttonType = "food"
        case "Leisure".localized():
            buttonType = "leisure"
        case "Transportation".localized():
            buttonType = "transportation"
        default:
            break
        }
        if !isSelected {
            self.notSelectedBackgroundView(button: buttonType)
        } else {
            self.selectedBackgroundView(button: buttonType)
        }
        return buttonType
    }
    
    func selectedBackgroundView(button: String) {
        icon.image = UIImage(named: "\(button)Selected")
    }
    
    func notSelectedBackgroundView(button: String) {
        icon.image = UIImage(named: "\(button)")
    }
}
