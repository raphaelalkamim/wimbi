//
//  CurrencyTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 21/09/22.
//j

import Foundation
import UIKit
 
protocol CurrencyTableViewCellDelegate: AnyObject {
    func didChangeFormatter(formatter: String)
}

class CurrencyTableViewCell: UITableViewCell {
    static let identifier = "currencyCell"
    let designSystem = DefaultDesignSystem.shared
    weak var delegate: CurrencyTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Teste"
        label.stylize(with: designSystem.text.body)
        return label
    }()
    
    lazy var currency: UILabel = {
        let label = UILabel()
        label.text = "Teste"
        label.stylize(with: designSystem.text.body)
        label.textColor = designSystem.palette.caption
        return label
    }()
    
    lazy var buttonCurrency: UIButton = {
        let button = UIButton()
        button.setTitle("Real", for: .normal)
        button.setImage(UIImage(systemName: "chevron.up.chevron.down"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.showsMenuAsPrimaryAction = true
        button.setTitleColor(designSystem.palette.textPrimary, for: .normal)
        return button
    }()

}

extension CurrencyTableViewCell {
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundCell
        contentView.addSubview(label)
        contentView.addSubview(buttonCurrency)
        setupConstraints()
        setContextViewCurrency()
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
  
        }
        buttonCurrency.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(designSystem.spacing.largePositive)
        }
    }
    
    func setupSeparator() {
        let separator = UIView()
        self.addSubview(separator)
        separator.backgroundColor = .gray
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.trailing.equalToSuperview()
        }
    }
}

extension CurrencyTableViewCell {
    func setContextViewCurrency() {
        let real = UIAction(title: NSLocalizedString("BRL", comment: "Brazilian currency Real"), image: UIImage(systemName: "brazilianrealsign.circle.fill")) { action in
            self.setCurrencyLabel(currency: "Real")
            self.delegate?.didChangeFormatter(formatter: "R$")
        }
        
        let dollar = UIAction(title: NSLocalizedString("USD", comment: "United States currency Dollar"), image: UIImage(systemName: "dollarsign.circle.fill")) { action in
            self.setCurrencyLabel(currency: "Dollar")
            self.delegate?.didChangeFormatter(formatter: "U$")
        }
        
        let euro = UIAction(title: NSLocalizedString("EUR", comment: "European currency Euro"), image: UIImage(systemName: "eurosign.circle.fill")) { action in
            self.setCurrencyLabel(currency: "Euro")
            self.delegate?.didChangeFormatter(formatter: "€")
        }
        
        let yen = UIAction(title: NSLocalizedString("JPY", comment: " Japonese currency Yen"), image: UIImage(systemName: "yensign.circle.fill")) { action in
            self.setCurrencyLabel(currency: "Yen")
            self.delegate?.didChangeFormatter(formatter: "¥")
        }
        
        let swiss = UIAction(title: NSLocalizedString("CHF", comment: "Swiss currency Swiss Franc"), image: UIImage(systemName: "francsign.circle.fill")) { action in
            self.setCurrencyLabel(currency: "Swiss Franc")
            self.delegate?.didChangeFormatter(formatter: "Fr")
        }
        
        let renminbi = UIAction(title: NSLocalizedString("CNY", comment: "Chinese currency Renminbi"), image: UIImage(systemName: "yensign.circle.fill")) { action in
            self.setCurrencyLabel(currency: "Renminbi")
            self.delegate?.didChangeFormatter(formatter: "¥")
        }
        buttonCurrency.menu = UIMenu(title: "", options: .displayInline ,children: [real, dollar, euro, yen, swiss, renminbi])
    }
    
    func setCurrencyLabel(currency: String) {
        self.buttonCurrency.setTitle(currency, for: .normal)
    }
}
