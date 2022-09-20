//
//  IconSubtitleViewComponent.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 16/09/22.
//

import Foundation
import UIKit

class IconSubtitleComponentView: UIButton {
    let designSystem = DefaultDesignSystem.shared
    
    var image: UIImage
    var label: String = ""
    
    init(image: UIImage, label: String) {
        self.image = image
        self.label = label
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = self.image
        return icon
    }()

    lazy var iconDescription: UILabel = {
        let description = UILabel()
        description.text = self.label
        description.stylize(with: designSystem.text.smallCaption)
        return description
    }()
        
}
extension IconSubtitleComponentView {
    func setup() {
        self.backgroundColor = .clear
        self.addSubview(icon)
        self.addSubview(iconDescription)
        setupConstraints()
    }
    
    func setupConstraints() {
        icon.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
            
        }
        iconDescription.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.centerX.equalTo(icon.snp.centerX)
        }
    }
}
