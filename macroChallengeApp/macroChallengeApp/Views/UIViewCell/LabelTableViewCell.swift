//
//  LabelTableViewCell.swift
//  macroChallengeApp
//
//  Created by Juliana Santana on 14/09/22.
//

import Foundation
import UIKit

class LabelTableViewCell: UITableViewCell {
    static let identifier = "labelCell"
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
    
   private lazy var title: UILabel = {
        let label = UILabel()
       label.stylize(with: designSystem.text.caption)
       label.textColor = designSystem.palette.textPrimary
        label.text = "Title"
        return label
    }()
    
    private lazy var value: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.caption)
        label.textColor = designSystem.palette.caption
        label.text = "Value"
        return label
    }()

    
    func setup() {
        contentView.addSubview(title)
        contentView.addSubview(value)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.top.equalToSuperview().offset(designSystem.spacing.largeNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.largePositive)
        }
        
        value.snp.makeConstraints { make in
            make.leading.equalTo(value.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(designSystem.spacing.xSmallNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.xSmallPositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
        }
    }
}
