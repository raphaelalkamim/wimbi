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
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 8
        stack.isUserInteractionEnabled = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

extension StackTableViewCell {
    func setup() {
        contentView.addSubview(title)
        contentView.addSubview(stack)
        
        stack.addArrangedSubview(IconSubtitleComponentView(image: designSystem.images.camp, label: "Alimentação"))
        stack.addArrangedSubview(IconSubtitleComponentView(image: designSystem.images.beach, label: "Hospedagem"))
        stack.addArrangedSubview(IconSubtitleComponentView(image: designSystem.images.mountain, label: "Lazer"))
        stack.addArrangedSubview(IconSubtitleComponentView(image: designSystem.images.city, label: "Transporte"))
        
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
