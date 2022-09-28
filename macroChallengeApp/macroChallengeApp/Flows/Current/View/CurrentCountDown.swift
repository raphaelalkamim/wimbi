//
//  CurrentCountDown.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 26/09/22.
//

import Foundation
import UIKit

class CurrentCountDown: UIView {
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
        label.text = "Switzerland"
        return label
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.body)
        label.textAlignment = .left
        label.text = "02.10.2022"
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = designSystem.images.compass
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.body)
        label.textAlignment = .left
        label.text = "Left"
        return label
    }()
    
    lazy var timer: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Avenir-Black", size: 70)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.text = "13"
        return label
    }()
    
    lazy var timerType: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.body)
        label.textAlignment = .left
        label.text = "days"
        return label
    }()
}

extension CurrentCountDown {
    func setup() {
        addSubview(title)
        addSubview(date)
        addSubview(image)
        addSubview(subtitle)
        addSubview(timer)
        addSubview(timerType)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
        }
        
        date.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(designSystem.spacing.smallPositive)
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(date.snp.bottom).offset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height/2.5)
            make.width.equalTo(UIScreen.main.bounds.width/1.5)
        }
        
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(designSystem.spacing.xxLargePositive)
            make.trailing.leading.equalToSuperview().inset(designSystem
                .spacing.xxLargePositive)
        }
        
        timer.snp.makeConstraints { make in
            make.top.equalTo(subtitle.snp.bottom)
            make.leading.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
        }
        
        timerType.snp.makeConstraints { make in
            make.bottom.equalTo(timer.snp.bottom).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(timer.snp.trailing).offset(designSystem.spacing.xSmallPositive)
        }
    }
}
