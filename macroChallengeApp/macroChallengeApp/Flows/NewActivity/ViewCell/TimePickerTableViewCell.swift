//
//  HourTableViewCell.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 20/09/22.
//

import Foundation
import UIKit

class TimePickerTableViewCell: UITableViewCell {
    static let identifier = "TimeCell"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Teste"
        label.stylize(with: designSystem.text.body)
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    let designSystem = DefaultDesignSystem.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = designSystem.palette.backgroundCell
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundCell
       
        contentView.addSubview(label)
        contentView.addSubview(datePicker)
        setupConstraints()
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.top.equalToSuperview().offset(designSystem.spacing.largeNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.largePositive)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(designSystem.spacing.xSmallNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.xSmallPositive)
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
