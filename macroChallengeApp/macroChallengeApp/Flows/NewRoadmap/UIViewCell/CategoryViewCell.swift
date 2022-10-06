//
//  CategoryViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 12/09/22.
//

import Foundation
import UIKit
import SnapKit

class CategoryViewCell: UICollectionViewCell {
    static let identifier = "categoryCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.stylize(with: designSystem.text.title)
        return title
    }()
    
    lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.stylize(with: designSystem.text.caption)
        return subtitle
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
}

extension CategoryViewCell {
    func setup() {
        self.addSubview(title)
        self.addSubview(subtitle)
        self.addSubview(icon)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(icon.snp.leading).inset(-16)
            make.top.equalToSuperview().inset(10)
        }
        
        subtitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(icon.snp.leading).inset(-16)
            make.top.equalTo(title.snp.bottom).inset(-8)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.trailing)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(self.snp.height).inset(10)
        }
    }
    
    func setCell(title: String, subtitle: String, icon: String) {
        self.title.text = title
        self.subtitle.text = subtitle
        self.icon.image = UIImage(named: icon)
    }
}

extension CategoryViewCell {
    func selectedBackgroundView() {
        self.layer.borderWidth = 1.5
        self.layer.borderColor = designSystem.palette.caption.cgColor
    }
    
    func notSelectedBackgroundView() {
        self.layer.borderWidth = 0
    }
}
