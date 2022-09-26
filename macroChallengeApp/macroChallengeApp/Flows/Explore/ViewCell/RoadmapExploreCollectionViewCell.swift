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
        label.text = "Vargem Grande Paulista"
        return label
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.text = "1 viajante  •  3 dias"
        label.stylize(with: designSystem.text.body)
        return label
    }()
    
    lazy var costByPerson: UILabel = {
        let label = UILabel()
        label.text = "R$ 2.5 mil por pessoa"
        label.stylize(with: designSystem.text.body)
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
        title.font = UIFont(name: "Avenir-Light", size: 12)
        title.text = "5.5k"
        return title
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
    }
}
