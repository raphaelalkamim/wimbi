//
//  ValueTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 20/09/22.
//

import Foundation
import UIKit

class ValueTableViewCell: UITableViewCell {
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
    
    let formatterTextField: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    let formatterNumber: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
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
            make.trailing.equalTo(value.snp.leading).inset(designSystem.spacing.largePositive)
            
        }
        value.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(designSystem.spacing.largePositive)
        }
    }
}

extension ValueTableViewCell: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
}
