//
//  NotificationPickerTableViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 19/09/22.
//

import Foundation
import UIKit
import SnapKit

class NotificationPickerTableViewCell: UITableViewCell {
    static let identifier = "notificationPickerCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let dataArray = ["minutes".localized(), "hours".localized(), "days".localized()]
    let dataTravel = ["traveler".localized(), "travelers".localized()]
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
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.stylize(with: designSystem.text.body)
        return title
    }()
    
    lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
}

extension NotificationPickerTableViewCell {
    func setup() {
        backgroundColor = .backgroundCell
        contentView.addSubview(title)
        contentView.addSubview(picker)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(designSystem.spacing.mediumPositive)
            make.leading.equalToSuperview().inset(designSystem.spacing.largePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargeNegative)
        }
        
        picker.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(designSystem.spacing.largePositive)
            make.top.equalToSuperview().inset(designSystem.spacing.largeNegative)
            make.bottom.equalToSuperview().inset(designSystem.spacing.smallPositive)
        }
        
    }
}

extension NotificationPickerTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if title.text == "Itinerary to".localized() {
            if component == 0 {
                return 30
            } else {
                return dataTravel.count
            }
        } else {
            if component == 0 {
                return 30
            } else {
                return dataArray.count
            }
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if title.text == "Itinerary to".localized() {
            if component == 0 {
                return "\(row + 1)"
            } else {
                let row = dataTravel[row]
                return row
            }
        } else {
            if component == 0 {
                return "\(row + 1)"
            } else {
                let row = dataArray[row]
                return row
            }
        }

    }
}
