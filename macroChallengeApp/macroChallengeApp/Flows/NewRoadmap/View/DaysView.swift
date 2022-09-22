//
//  DaysView.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 13/09/22.
//

import UIKit

class DaysView: UIView {    
    let designSystem = DefaultDesignSystem.shared
    public var isPublic = false
    
    lazy var dataTitleLabel: UILabel = {
        let dataTitleLabel = UILabel()
        dataTitleLabel.stylize(with: designSystem.text.caption)
        dataTitleLabel.text = "DATA"
        return dataTitleLabel
    }()
    
    lazy var daysTableView: UITableView = {
        let daysTableView = UITableView()
        daysTableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DayCell")
        daysTableView.layer.cornerRadius = 16
        daysTableView.isScrollEnabled = false
        daysTableView.separatorColor = .clear
        daysTableView.allowsSelection = false
        return daysTableView
    }()
    
    lazy var viajantesTitleLabel: UILabel = {
        let viajantesTitleLabel = UILabel()
        viajantesTitleLabel.text = "VIAJANTES"
        return viajantesTitleLabel
    }()
    
    lazy var numberPickerTableView: UITableView = {
        let numberPickerTableView = UITableView()
        numberPickerTableView.register(NumberPickerTableViewCell.self, forCellReuseIdentifier: "NumberCell")
        numberPickerTableView.layer.cornerRadius = 16
        numberPickerTableView.isScrollEnabled = false
        numberPickerTableView.separatorColor = .clear
        numberPickerTableView.allowsSelection = false
        return numberPickerTableView
    }()
    
    lazy var publicTitle: UILabel = {
        let publicTitle = UILabel()
        publicTitle.text = "Deixar essa viagem pública"
        return publicTitle
    }()
    
    lazy var publicCaption: UILabel = {
        let publicCaption = UILabel()
        publicCaption.text = "Ao deixar sua viagem pública, ela será publicada para todos os usuários do aplicativo."
        return publicCaption
    }()
    
    lazy var publicSwitch: UISwitch = {
        let publicSwitch = UISwitch()
        publicSwitch.addTarget(self, action: #selector(turnRoadmapPublic(_:)), for: .valueChanged)
        return publicSwitch
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
        self.addSubview(publicTitle)
        self.addSubview(publicCaption)
        self.addSubview(publicSwitch)

        viajantesTitleLabel.stylize(with: designSystem.text.caption)
        publicTitle.stylize(with: designSystem.text.body)
        publicCaption.stylize(with: designSystem.text.caption)

        setupConstraints()
    }
    
    @objc func turnRoadmapPublic(_ sender: UISwitch!) {
        if sender.isOn {
            print("on")
            isPublic = true
        } else {
            isPublic = false
        }
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
        
        publicTitle.snp.makeConstraints { make in
            make.top.equalTo(numberPickerTableView.snp.bottom).offset(26)
            make.leading.equalToSuperview().offset(designSystem.spacing.xLargePositive)
        }
        
        publicSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(publicTitle.snp.centerY)
            make.leading.equalTo(publicTitle.snp.trailing).offset(70)
            make.trailing.equalToSuperview().offset(designSystem.spacing.xLargeNegative)
        }
        
        publicCaption.snp.makeConstraints { make in
            make.top.equalTo(publicTitle.snp.bottom).offset(designSystem.spacing.largePositive)
            make.leading.equalToSuperview().offset(designSystem.spacing.xLargePositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.xLargeNegative)
        }
    }
    
}
