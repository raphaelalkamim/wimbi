//
//  DatePickerTableViewCell.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 13/09/22.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {
    static let identifier = "DayCell"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Teste"
        label.stylize(with: designSystem.text.body)
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
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
    
    func setupDate(date: String, dateInitial: Date, dateFinal: Date) {
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .short
        self.datePicker.maximumDate = dateFinal
        self.datePicker.minimumDate = dateInitial
        self.datePicker.date = format.date(from: date) ?? dateFinal
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
