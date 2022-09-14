//
//  ReviewTravelViewController.swift
//  macroChallengeApp
//
//  Created by Juliana Santana on 13/09/22.
//

import Foundation
import UIKit

class ReviewTravelView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "beachView")
        image.layer.cornerRadius = 16
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.backgroundColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var categoryImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.image = UIImage(named: "categoryBeach")
        return image
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = designSystem.palette.titlePrimary
        title.stylize(with: designSystem.text.title)
        title.text = "Fernando de Noronha"
        return title
    }()
    
    private lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.stylize(with: designSystem.text.caption)
        subtitle.textColor = designSystem.palette.textPrimary
        subtitle.text = "Praia"
        return subtitle
    }()
    
}

extension ReviewTravelView {
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(coverImage)
        self.addSubview(categoryImage)
        self.addSubview(title)
        self.addSubview(subtitle)
        setupConstraints()
    }
    
    func setupConstraints() {
        coverImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(150)
        }
        
        categoryImage.snp.makeConstraints { make in
            make.top.equalTo(coverImage.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.width.equalTo(64)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(coverImage.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(categoryImage.snp.trailing).inset(designSystem.spacing.xLargeNegative)
            make.height.equalTo(35)
        }
        
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(categoryImage.snp.trailing).inset(designSystem.spacing.xLargeNegative)
            make.height.equalTo(16)
            
        }
    }
}
