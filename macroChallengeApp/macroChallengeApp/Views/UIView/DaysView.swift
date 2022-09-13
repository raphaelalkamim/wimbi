//
//  DaysView.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 13/09/22.
//

import UIKit

class DaysView: UIView {
    
    let designSystem = DefaultDesignSystem.shared
    var dataTitleLabel: UILabel
    var daysTableView: UITableView
    
    var viajantesTitleLabel: UILabel
    
    override init(frame: CGRect) {
        dataTitleLabel = UILabel()
        daysTableView = UITableView()
        viajantesTitleLabel = UILabel()
        
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        
        self.addSubview(dataTitleLabel)
        dataTitleLabel.stylize(with: designSystem.text.caption)
        dataTitleLabel.text = "DATA"
        
        dataTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin).offset(designSystem.spacing.largePositive)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
        }

        self.addSubview(daysTableView)
        daysTableView.snp.makeConstraints { make in
            make.top.equalTo(dataTitleLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
            make.height.equalTo(100)
        }
        
        daysTableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DayCell")
        daysTableView.layer.cornerRadius = 16
        daysTableView.isScrollEnabled = false
        daysTableView.separatorColor = .clear
        
        self.addSubview(viajantesTitleLabel)
        viajantesTitleLabel.stylize(with: designSystem.text.caption)
        viajantesTitleLabel.text = "VIAJANTES"
        
        viajantesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(daysTableView.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
        }
    }
    
}
