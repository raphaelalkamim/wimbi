//
//  ValueTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 20/09/22.
//

import Foundation
import UIKit

class ValueTableViewCell: UITableViewCell, UITextFieldDelegate {
    static let identifier = "valueCell"
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
    
    public lazy var title: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.body)
        label.text = "Title"
        return label
     }()
    
    lazy var value: UITextField = {
        let textField = UITextField()
        textField.textColor = designSystem.palette.caption
        textField.textColor = designSystem.palette.textPrimary
        textField.placeholder = "Value"
        textField.textAlignment = .right
        textField.font = .body
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
}

extension ValueTableViewCell {
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundCell
        contentView.addSubview(title)
        contentView.addSubview(value)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            
        }
        value.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(title.snp.trailing).offset(designSystem.spacing.xxLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.largePositive)
      
        }
    }
}
