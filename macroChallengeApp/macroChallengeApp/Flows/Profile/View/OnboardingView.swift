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
        title.text = "A primeira rede social de viagens".localized() // adicionar nome
        title.stylize(with: designSystem.text.body)
        title.textAlignment = .center
        return title
    }()
    
    lazy var createTitle: UILabel = {
        let title = UILabel()
        title.text = "Seja um explorador".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var createSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "Crie o seu roteiro e deixe-o público para pessoas curtirem e poderem usá-lo como inspiração.".localized()
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
        title.text = "Explore roteiros sem fazer login".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var duplicateSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "Caso encontre um roteiro ideal, duplique-o para poder editá-lo a qualquer momento.".localized()
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
        title.text = "Não perca nenhum roteiro".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var likeSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "Curta um roteiro para que ele fique salvo nas configurações.".localized()
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
        title.text = "Viaje junto com seus amigos".localized()
        title.stylize(with: designSystem.text.cellTitle)
        return title
    }()
    
    lazy var shareSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "Compartilhe seu roteiro com seus amigos para que todos possam modificá-lo.".localized()
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
        button.setAttributedTitle(NSAttributedString(string: "Explore", attributes: attributes), for: .normal)
        button.backgroundColor = .accent
        button.setTitleColor(.backgroundPrimary, for: .normal)
        button.layer.cornerRadius = 16
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
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
        
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.xLargeNegative)
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
            make.top.equalTo(createTitle.snp.top).inset(27)
            make.bottom.equalTo(createSubtitle.snp.bottom).inset(27)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(designSystem.spacing.xLargeNegative)
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
            make.top.equalTo(duplicateTitle.snp.top).inset(17)
            make.bottom.equalTo(duplicateSubtitle.snp.bottom).inset(17)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(designSystem.spacing.xLargeNegative)
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
            make.top.equalTo(likeTitle.snp.top).inset(17)
            make.bottom.equalTo(likeSubtitle.snp.bottom).inset(17)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(designSystem.spacing.xLargeNegative)
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
            make.top.equalTo(shareTitle.snp.top).inset(17)
            make.bottom.equalTo(shareSubtitle.snp.bottom).inset(17)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(createSubtitle.snp.leading).inset(designSystem.spacing.xLargeNegative)
        }
        
        exploreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(300)
            make.leading.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.top.equalTo(likeSubtitle.snp.bottom).inset(-220)
        }
        
    }
    
}
