//
//  InfoTripCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import UIKit

class InfoTripCollectionViewCell: UICollectionViewCell {
    static let identifier = "infoCell"
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
        title.textColor = .textPrimary
        title.font = designSystem.text.caption.font
        title.textAlignment = .center
        title.text = "OIOIOI"
        return title
    }()
    
    lazy var separator: UIView = {
       let separator = UIView()
        separator.backgroundColor = .caption
        return separator
    }()
    
    lazy var infoTitle: UILabel = {
        let title = UILabel()
        title.textColor = .textPrimary
        title.font = designSystem.text.infoTitle.font
        title.textAlignment = .center
        title.text = "R$12 mil"
        return title
    }()
    
    lazy var info: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        btn.setImage(img, for: .normal)
        btn.tintColor = .textPrimary
        btn.setTitle(" 10K", for: .normal)
        btn.setTitleColor(designSystem.palette.textPrimary, for: .normal)
        btn.titleLabel?.font = designSystem.text.infoTitle.font
//        btn.titleLabel?.textColor = .textPrimary
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
}

extension InfoTripCollectionViewCell {
    func setup() {
        contentView.addSubview(title)
        contentView.addSubview(info)
        contentView.addSubview(infoTitle)
        contentView.addSubview(separator)
        self.backgroundColor = .backgroundPrimary
        self.layer.cornerRadius = 13
        infoTitle.isHidden = true
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalToSuperview().inset(designSystem.spacing.smallPositive)
        }
        info
            .snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.smallNegative)
        }
        
        infoTitle
            .snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.smallNegative)
        }
        
        separator.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing)
            make.centerY.equalToSuperview()
            make.top.equalTo(contentView.snp.topMargin).inset(designSystem.spacing.xSmallPositive)
            make.bottom.equalTo(contentView.snp.bottomMargin).inset(designSystem.spacing.xSmallPositive)
            make.width.equalTo(0.5)
        }
        
    }
}
