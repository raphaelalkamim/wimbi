//
//  CurrentEmptyState.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 26/09/22.
//

import Foundation
import UIKit

class CurrentEmptyState: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.title)
        label.text = "Oops.. It looks like you don't have any itinerary yet!".localized()
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = designSystem.images.flora
        image.contentMode = .scaleAspectFill

        return image
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.body)
        label.textAlignment = .right
        label.text = "Go to the Explore screen and create a new one. That way, you'll be able to track how much time is left for your much-desired trip and when that time arrives, here you'll find a shortcut to it.".localized()
        return label
    }()
}

extension CurrentEmptyState {
    func setup() {
        addSubview(title)
        addSubview(image)
        addSubview(subtitle)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(designSystem.spacing.largePositive)
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(50)
            make.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2.5)
            make.width.equalTo(UIScreen.main.bounds.width / 1.5)
        }
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).inset(-40)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.width.equalToSuperview().inset(40)
        }
    }
}
