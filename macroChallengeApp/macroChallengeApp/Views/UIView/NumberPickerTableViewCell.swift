//
//  NumberPickerTableViewCell.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 14/09/22.
//

import UIKit

class NumberPickerTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    var label = UILabel()
    var numberPicker = UIPickerView()
    let designSystem = DefaultDesignSystem.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(numberPicker)
        
        numberPicker.dataSource = self
        numberPicker.delegate = self
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.top.equalToSuperview().offset(designSystem.spacing.largeNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.largePositive)
        }
        
        numberPicker.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(designSystem.spacing.xSmallNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.xSmallPositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
}
