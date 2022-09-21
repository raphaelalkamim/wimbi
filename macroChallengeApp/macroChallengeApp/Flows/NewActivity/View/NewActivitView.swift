//
//  NewActivity.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 14/09/22.
//

import Foundation
import UIKit

class NewActivityView: UIView {
    let designSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "TYPE"
        label.stylize(with: designSystem.text.caption)
        return label
    }()
    
    lazy var categoryTable: UITableView = {
        let table = UITableView()
        table.register(StackTableViewCell.self, forCellReuseIdentifier: StackTableViewCell.identifier)
        table.layer.cornerRadius = 16
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = false
        
        return table
    }()
    
    lazy var localyLabel: UILabel = {
        let label = UILabel()
        label.text = "LOCALY"
        label.stylize(with: designSystem.text.caption)
        return label
    }()
    
    lazy var localyTable: UITableView = {
        let table = UITableView()
        table.register(AddressTableViewCell.self, forCellReuseIdentifier: AddressTableViewCell.identifier)
        table.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        table.layer.cornerRadius = 16
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = true
        
        return table
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "TIME"
        label.stylize(with: designSystem.text.caption)
        return label
    }()
    
    lazy var dateTable: UITableView = {
        let table = UITableView()
        table.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        table.register(TimePickerTableViewCell.self, forCellReuseIdentifier: TimePickerTableViewCell.identifier)
        table.layer.cornerRadius = 16
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = false
        
        return table
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "EXPENSE"
        label.stylize(with: designSystem.text.caption)
        return label
    }()
    
    lazy var valueTable: UITableView = {
        let table = UITableView()
        table.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.identifier)
        table.register(ValueTableViewCell.self, forCellReuseIdentifier: ValueTableViewCell.identifier)
        table.layer.cornerRadius = 16
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = false

        return table
    }()
}

extension NewActivityView {
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        
        self.addSubview(categoryLabel)
        self.addSubview(categoryTable)
        
        self.addSubview(localyLabel)
        self.addSubview(localyTable)
        
        self.addSubview(dateLabel)
        self.addSubview(dateTable)
        
        self.addSubview(valueLabel)
        self.addSubview(valueTable)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin).offset(designSystem.spacing.largePositive)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        categoryTable.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.trailing.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }
        
        localyLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTable.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        localyTable.snp.makeConstraints { make in
            make.top.equalTo(localyLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.trailing.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(localyTable.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        dateTable.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.trailing.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTable.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        valueTable.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.trailing.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }
    }
}

extension NewActivityView {
    func bindColletionView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        categoryTable.delegate = delegate
        categoryTable.dataSource = dataSource
        
        localyTable.delegate = delegate
        localyTable.dataSource = dataSource
        
        dateTable.delegate = delegate
        dateTable.dataSource = dataSource
        
        valueTable.delegate = delegate
        valueTable.dataSource = dataSource
    }
}
