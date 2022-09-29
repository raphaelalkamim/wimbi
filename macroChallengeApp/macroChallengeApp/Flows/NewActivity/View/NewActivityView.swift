//
//  NewActivityView.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 14/09/22.
//

import Foundation
import UIKit

class NewActivityView: UIView {
    let designSystem = DefaultDesignSystem.shared
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "TYPE".localized()
        label.stylize(with: designSystem.text.caption)
        return label
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(CategoryActivityCollectionViewCell.self, forCellWithReuseIdentifier: CategoryActivityCollectionViewCell.identifier)
        collectionView.backgroundColor = .backgroundCell
        collectionView.isUserInteractionEnabled = true
        collectionView.layer.cornerRadius = 16
        return collectionView
    }()
    
    lazy var localyLabel: UILabel = {
        let label = UILabel()
        label.text = "LOCATION".localized()
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
        label.text = "TIME".localized()
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
        label.text = "EXPENSE".localized()
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
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryCollectionView)
        
        contentView.addSubview(localyLabel)
        contentView.addSubview(localyTable)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateTable)
        
        contentView.addSubview(valueLabel)
        contentView.addSubview(valueTable)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(valueTable.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(designSystem.spacing.largePositive)
            make.leading.equalTo(contentView.snp.leading).inset(32)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }
        
        localyLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(32)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }

        localyTable.snp.makeConstraints { make in
            make.top.equalTo(localyLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(localyTable.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(32)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }

        dateTable.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTable.snp.bottom).offset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(32)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }

        valueTable.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(designSystem.spacing.xSmallPositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
}

extension NewActivityView {
    func bindTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {        
        localyTable.delegate = delegate
        localyTable.dataSource = dataSource
        
        dateTable.delegate = delegate
        dateTable.dataSource = dataSource
        
        valueTable.delegate = delegate
        valueTable.dataSource = dataSource
    }
    
    func bindCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        categoryCollectionView.delegate = delegate
        categoryCollectionView.dataSource = dataSource
    }
}
