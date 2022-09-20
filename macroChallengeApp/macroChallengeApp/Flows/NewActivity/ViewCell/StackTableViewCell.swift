//
//  StackTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 15/09/22.
//

import Foundation
import UIKit

class StackTableViewCell: UITableViewCell {
    static let identifier = "stakeCell"
    let designSystem = DefaultDesignSystem.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.stylize(with: designSystem.text.caption)
        title.textColor = designSystem.palette.textPrimary
        title.text = "Title"
        return title
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 8
        stack.isUserInteractionEnabled = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var foodButtom: IconSubtitleComponentView = {
        let type = "Food"
        let buttom = IconSubtitleComponentView(image: designSystem.images.camp, label: type)
        buttom.addTarget(self, action: #selector(didSelectedType), for: .touchUpInside)
        return buttom
    }()
    
    lazy var accommodationButtom: IconSubtitleComponentView = {
        let type = "Accommodation"
        let buttom = IconSubtitleComponentView(image: designSystem.images.camp, label: type)
        buttom.addTarget(self, action: #selector(didSelectedType), for: .touchUpInside)
        return buttom
    }()
    
    lazy var leisureButtom: IconSubtitleComponentView = {
        let type = "Leisure"
        let buttom = IconSubtitleComponentView(image: designSystem.images.camp, label: type)
        buttom.addTarget(self, action: #selector(didSelectedType), for: .touchUpInside)
        return buttom
    }()
    
    lazy var transportationButtom: IconSubtitleComponentView = {
        let type = "Transportation"
        let buttom = IconSubtitleComponentView(image: designSystem.images.camp, label: type)
        buttom.addTarget(self, action: #selector(didSelectedType), for: .touchUpInside)
        return buttom
    }()
    
    
}

extension StackTableViewCell {
    func setup() {
        contentView.addSubview(stack)
        
        stack.addArrangedSubview(foodButtom)
        stack.addArrangedSubview(accommodationButtom)
        stack.addArrangedSubview(leisureButtom)
        stack.addArrangedSubview(transportationButtom)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
}

extension StackTableViewCell {
    @objc func didSelectedType() {
        print("taped")
    }
}
