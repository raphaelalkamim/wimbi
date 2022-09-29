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
        label.text = "How about exploring and booking a new trip?"
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = designSystem.images.flora
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.body)
        label.textAlignment = .right
        label.text = "Go to Explore and find a new trip or create your own."
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
            make.topMargin.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height/2.5)
            make.width.equalTo(UIScreen.main.bounds.width/1.5)
        }
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.width.equalToSuperview().inset(50)
        }
    }
}