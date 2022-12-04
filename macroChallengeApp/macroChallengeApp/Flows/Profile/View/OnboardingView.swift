//
//  OnboardingView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 01/11/22.
//

import Foundation
import UIKit
import SnapKit

class OnboardingView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.text = "wimbi".localized() // adicionar nome
        title.stylize(with: designSystem.text.largeTitle)
        return title
    }()
    
    lazy var subtitle: UILabel = {
        let title = UILabel()
        title.text = "The first travel social network".localized() // adicionar nome
        title.stylize(with: designSystem.text.body)
        title.textAlignment = .center
        return title
    }()
    
    lazy var createTitle: UILabel = {
        let title = UILabel()
        title.text = "Be an explorer".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var createSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "Create your itinerary and make it public for people to enjoy and use as inspiration.".localized()
        subtitle.stylize(with: designSystem.text.caption)
        return subtitle
    }()
    
    lazy var createIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "plus")
        icon.tintColor = .accent
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    lazy var duplicateTitle: UILabel = {
        let title = UILabel()
        title.text = "Explore itineraries without sign in".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var duplicateSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "If you find a perfect itinerary, duplicate it so you can edit it at any time.".localized()
        subtitle.stylize(with: designSystem.text.caption)
        return subtitle
    }()
    
    lazy var duplicateIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "plus.square.on.square")
        icon.tintColor = .accent
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    lazy var likeTitle: UILabel = {
        let title = UILabel()
        title.text = "Don't miss any itinerary".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var likeSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "Like a itinerary so that it's saved in settings.".localized()
        subtitle.stylize(with: designSystem.text.caption)
        return subtitle
    }()
    
    lazy var likeIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "heart")
        icon.tintColor = .accent
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    lazy var shareTitle: UILabel = {
        let title = UILabel()
        title.text = "Travel together with your friends".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var shareSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "Share your itinerary with your friends so everyone can edit it.".localized()
        subtitle.stylize(with: designSystem.text.caption)
        return subtitle
    }()
    
    lazy var shareIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "square.and.arrow.up")
        icon.tintColor = .accent
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    lazy var exploreButton: UIButton = {
        let button = UIButton()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 17)]
        button.setAttributedTitle(NSAttributedString(string: "Explore", attributes: attributes as [NSAttributedString.Key: Any]), for: .normal)
        button.backgroundColor = .accent
        button.setTitleColor(.backgroundPrimary, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        return button
    }()
    
    func setup() {
        self.backgroundColor = .backgroundPrimary
        self.addSubview(title)
        self.addSubview(subtitle)
        self.addSubview(createTitle)
        self.addSubview(createSubtitle)
        self.addSubview(createIcon)
        self.addSubview(duplicateTitle)
        self.addSubview(duplicateSubtitle)
        self.addSubview(duplicateIcon)
        self.addSubview(likeTitle)
        self.addSubview(likeSubtitle)
        self.addSubview(likeIcon)
        self.addSubview(shareTitle)
        self.addSubview(shareSubtitle)
        self.addSubview(shareIcon)
        self.addSubview(exploreButton)
        self.addSubview(okButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(52)
            make.centerX.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.centerX.equalToSuperview()
        }
        createTitle.snp.makeConstraints { make in
            make.top.equalTo(subtitle.snp.bottom).inset(-40)
            make.leading.equalToSuperview().inset(90)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            
        }
        createSubtitle.snp.makeConstraints { make in
            make.top.equalTo(createTitle.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.leading.equalTo(createTitle.snp.leading)
            make.trailing.equalTo(createTitle.snp.trailing)
        }
        
        createIcon.snp.makeConstraints { make in
            make.top.equalTo(createTitle.snp.top)
            make.bottom.equalTo(createSubtitle.snp.bottom)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(-25)
        }
        
        duplicateTitle.snp.makeConstraints { make in
            make.top.equalTo(createSubtitle.snp.bottom).inset(-32)
            make.leading.equalTo(createTitle.snp.leading)
            make.trailing.equalTo(createTitle.snp.trailing)
            
        }
        duplicateSubtitle.snp.makeConstraints { make in
            make.top.equalTo(duplicateTitle.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.leading.equalTo(createTitle.snp.leading)
            make.trailing.equalTo(createTitle.snp.trailing)
        }
        
        duplicateIcon.snp.makeConstraints { make in
            make.top.equalTo(duplicateTitle.snp.top)
            make.bottom.equalTo(duplicateSubtitle.snp.bottom)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(-25)
        }
        
        likeTitle.snp.makeConstraints { make in
            make.top.equalTo(duplicateSubtitle.snp.bottom).inset(-32)
            make.leading.equalTo(createTitle.snp.leading)
            make.trailing.equalTo(createTitle.snp.trailing)
            
        }
        
        likeSubtitle.snp.makeConstraints { make in
            make.top.equalTo(likeTitle.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.leading.equalTo(createTitle.snp.leading)
            make.trailing.equalTo(createTitle.snp.trailing)
        }
        
        likeIcon.snp.makeConstraints { make in
            make.top.equalTo(likeTitle.snp.top)
            make.bottom.equalTo(likeSubtitle.snp.bottom)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(-25)
        }

        shareTitle.snp.makeConstraints { make in
            make.top.equalTo(likeSubtitle.snp.bottom).inset(-32)
            make.leading.equalTo(createTitle.snp.leading)
            make.trailing.equalTo(createTitle.snp.trailing)
            
        }
        
        shareSubtitle.snp.makeConstraints { make in
            make.top.equalTo(shareTitle.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.leading.equalTo(createTitle.snp.leading)
            make.trailing.equalTo(createTitle.snp.trailing)
        }
        
        shareIcon.snp.makeConstraints { make in
            make.top.equalTo(shareTitle.snp.top)
            make.bottom.equalTo(shareSubtitle.snp.bottom)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(-25)

        }
        
        exploreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(300)
            make.leading.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.bottom.equalToSuperview().inset(60)
        }
        
    }
    
}
