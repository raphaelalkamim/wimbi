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
    var currencyType: String = "U$"
    
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
        label.text = ""
        return label
     }()
    
    lazy var value: UITextField = {
        let textField = UITextField()
        textField.textColor = designSystem.palette.caption
        textField.textColor = designSystem.palette.textPrimary
        textField.placeholder = ""
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
        value.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
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
    
    func setCurrencyValue(currency: String, value: Double) {
        self.title.text = "Value".localized()
        self.currencyType = currency
        self.value.placeholder = "\(currency) 0.00"
        self.value.text = "\(currency) \(self.setNumber(number: value))"

    }
    func setNumber(number: Double) -> String {
        let numberText = String(number)
        var number = ""
        for index in 0..<numberText.count {
            if numberText[index].isNumber {
                number += String(numberText[index])
            } else if numberText[index] == "." {
                number += ","
            }
        }
        return number
    }
    func getNumber(textNumber: String, userCurrency: String) -> String {
        var number = ""
        for index in 0..<textNumber.count {
            if userCurrency == "R$" || userCurrency == "€"{
                if textNumber[index].isNumber {
                    number += String(textNumber[index])
                } else if textNumber[index] == "," {
                    return number
                }
            } else {
                if textNumber[index].isNumber {
                    number += String(textNumber[index])
                } else if textNumber[index] == "." {
                    return number
                }
            }
        }
        return number
    }
}

extension ValueTableViewCell: UITextFieldDelegate {
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting(symbol: currencyType) {
            textField.text = amountString
        }
    }
}

extension String {
    func currencyInputFormatting(symbol: String) -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = symbol
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
    
        var amountWithPrefix = self
    
        // remove from String: "$", ".", ","
        do {
            let regex = try NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
            amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
            let double = (amountWithPrefix as NSString).doubleValue
            number = NSNumber(value: (double / 100))
        
            // if first number is 0 or all numbers were deleted
            guard number != 0 as NSNumber else {
                return ""
            }
        } catch {
            print(error)
        }
        return formatter.string(from: number)!
    }
}
