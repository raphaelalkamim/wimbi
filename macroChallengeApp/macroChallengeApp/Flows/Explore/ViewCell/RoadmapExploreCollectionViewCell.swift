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
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cover: UIImageView = {
        let img = UIImageView()
        img.image = designSystem.imagesDefault.beach[3]
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 16
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return img
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.title)
        label.text = ""
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir-Roman", size: 15)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()
    
    lazy var costByPerson: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir-Roman", size: 15)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()
    
    lazy var heart: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        img.tintColor = .titlePrimary
        return img
    }()
    
    lazy var totalLikes: UILabel = {
        let title = UILabel()
        title.textColor = .textPrimary
        title.font = UIFont(name: "Avenir-Book", size: 12)
        title.text = ""
        return title
    }()
    
    lazy var category: UIView = {
        let category = UIView()
        category.backgroundColor = .backgroundPrimary
        category.layer.cornerRadius = 15
        return category
    }()
    
    lazy var categoryName: UILabel = {
        let title = UILabel()
        title.textColor = .textPrimary
        title.font = UIFont(name: "Avenir-Book", size: 12)
        title.text = "Praia"
        return title
    }()
    
    lazy var categoryColor: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "circle.fill")
        img.tintColor = .blueBeach
        return img
    }()
    
}

extension RoadmapExploreCollectionViewCell {
    func setup() {
        self.backgroundColor = .backgroundCell
        self.layer.cornerRadius = 16
        contentView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(costByPerson)
        contentView.addSubview(heart)
        contentView.addSubview(totalLikes)
        contentView.addSubview(category)
        category.addSubview(categoryColor)
        category.addSubview(categoryName)
        setupConstraints()
    }
    
    func setupConstraints() {
        cover.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(193)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        costByPerson.snp.makeConstraints { make in
            make.top.equalTo(subtitle.snp.bottom)
            make.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        heart.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).inset(-40)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        totalLikes.snp.makeConstraints { make in
            make.top.equalTo(heart.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.centerX.equalTo(heart.snp.centerX)
        }
        category.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.mediumPositive)
            make.trailing.equalTo(categoryName.snp.trailing).inset(designSystem.spacing.mediumNegative)
            make.top.equalToSuperview().inset(designSystem.spacing.mediumPositive)
            make.height.equalTo(30)
        }
        categoryColor.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.xSmallPositive)
            make.centerY.equalToSuperview()
        }
        categoryName.snp.makeConstraints { make in
            make.leading.equalTo(categoryColor.snp.trailing).inset(designSystem.spacing.smallNegative)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func setupColor(category: String) {
        if category == "Beach" {
            self.categoryColor.tintColor = .blueBeach
        } else if category == "Mountain" {
            self.categoryColor.tintColor = .yellowMontain
        } else if category == "City" {
            self.categoryColor.tintColor = .redCity
        } else {
            self.categoryColor.tintColor = .greenCamp
            
        }
    }
    
    func setupImage(category: String) -> String {
        return String("\(category)Cover")
    }
    
    func setupRoadmapMock(roadmap: Roadmaps) {
        self.setupContent(imageId: roadmap.imageId, name: roadmap.name, peopleCount: roadmap.peopleCount, dayCount: roadmap.dayCount, budget: roadmap.budget, currency: roadmap.currency, category: roadmap.category, likesCount: roadmap.likesCount)
    }
    func setupRoadmapBackEnd(roadmap: RoadmapDTO) {
        self.setupContent(imageId: roadmap.imageId, name: roadmap.name, peopleCount: roadmap.peopleCount, dayCount: roadmap.dayCount, budget: roadmap.budget, currency: roadmap.currency, category: roadmap.category, likesCount: roadmap.likesCount)
    }
    
    func setupContent(imageId: String, name: String, peopleCount: Int, dayCount: Int, budget: Double, currency: String, category: String, likesCount: Int) {
        cover.image = UIImage(named: imageId)
        
        if let cachedImage = FirebaseManager.shared.imageCash.object(forKey: NSString(string: imageId)) {
            cover.image = cachedImage
        } else {
            cover.image = UIImage(named: setupImage(category: category)) 
        }
        title.text = name
        var travelers = ""
        var days = ""
        if peopleCount == 1 {
            travelers = "traveler  •".localized()
        } else {
            travelers = "travelers  •".localized()
        }
        if dayCount == 1 {
            days = "day".localized()
        } else {
            days = "days".localized()
        }
        subtitle.text = "\(peopleCount) \(travelers)  \(dayCount) \(days)"
        var amount = "per person".localized()
        if budget > 1000 {
            amount = "thousand per person".localized()
            costByPerson.text = "\(currency) \(String(format: "%.2f", budget / Double(peopleCount) / 1000))  \(amount)"
        } else {
            costByPerson.text = "\(currency) \(String(format: "%.2f", budget / Double(peopleCount)))  \(amount)"
        }
        categoryName.text = category.localized()
        setupColor(category: category)
        totalLikes.text = "\(likesCount)"
    }
}
