//
//  DaysView.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 13/09/22.
//

import UIKit

class DaysView: UIView {
    
    let designSystem = DefaultDesignSystem.shared
    
    lazy var dataTitleLabel: UILabel = {
        let dataTitleLabel = UILabel()
        dataTitleLabel.stylize(with: designSystem.text.caption)
        dataTitleLabel.text = "DATA"
        return dataTitleLabel
    }()
    
    var daysTableView: UITableView = {
        let daysTableView = UITableView()
        daysTableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DayCell")
        daysTableView.layer.cornerRadius = 16
        daysTableView.isScrollEnabled = false
        daysTableView.separatorColor = .clear
        return daysTableView
    }()
    
    var viajantesTitleLabel: UILabel = {
        let viajantesTitleLabel = UILabel()
        viajantesTitleLabel.text = "VIAJANTES"
        return viajantesTitleLabel
    }()
    
    var numberPickerTableView: UITableView = {
        let numberPickerTableView = UITableView()
        numberPickerTableView.register(NumberPickerTableViewCell.self, forCellReuseIdentifier: "NumberCell")
        numberPickerTableView.layer.cornerRadius = 16
        numberPickerTableView.isScrollEnabled = false
        numberPickerTableView.separatorColor = .clear
        return numberPickerTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        
        self.addSubview(dataTitleLabel)
        self.addSubview(daysTableView)
        self.addSubview(viajantesTitleLabel)
        self.addSubview(numberPickerTableView)

        viajantesTitleLabel.stylize(with: designSystem.text.caption)

        setupConstraints()
    }
    
    func setupConstraints() {
        dataTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin).offset(designSystem.spacing.largePositive)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
        }
        
        daysTableView.snp.makeConstraints { make in
            make.top.equalTo(dataTitleLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
            make.height.equalTo(100)
        }
        
        viajantesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(daysTableView.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
        }
        
        numberPickerTableView.snp.makeConstraints { make in
            make.top.equalTo(viajantesTitleLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
            make.height.equalTo(50)
        }
        
    }
    
}
