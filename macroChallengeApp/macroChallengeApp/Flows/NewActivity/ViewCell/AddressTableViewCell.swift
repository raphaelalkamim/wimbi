//
//  AddressTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 21/09/22.
//

import Foundation
import UIKit

class AddressTableViewCell: UITableViewCell {
    static let identifier = "addressCell"
    let designSystem = DefaultDesignSystem.shared
    
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

}

extension AddressTableViewCell {
    func setup() {
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = designSystem.palette.backgroundCell
        contentView.addSubview(label)
        setupConstraints()
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
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
