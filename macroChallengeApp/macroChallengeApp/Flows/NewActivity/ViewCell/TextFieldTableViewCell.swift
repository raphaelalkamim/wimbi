//
//  TextFieldTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 15/09/22.
//

import Foundation
import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    static let identifier = "textFieldCell"
    let designSystem = DefaultDesignSystem.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    lazy var title: UITextField = {
        let textField = UITextField()
        textField.textColor = designSystem.palette.textPrimary
        textField.placeholder = "Title"
        textField.font = .body
        textField.delegate = self
        return textField
    }()
}

extension TextFieldTableViewCell {
    func setup() {
        contentView.addSubview(title)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
    }
}
