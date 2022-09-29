//
//  MyTripView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import SnapKit

class MyTripView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var infoTripCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 90)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.register(InfoTripCollectionViewCell.self, forCellWithReuseIdentifier: InfoTripCollectionViewCell.identifier)
        collection.isUserInteractionEnabled = true
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .backgroundPrimary
        return collection
    }()
    
    lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: frame, collectionViewLayout: layout)
        collection.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        collection.isUserInteractionEnabled = true
        collection.isPagingEnabled = true
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .backgroundPrimary
        return collection
    }()
    
    lazy var infoTitle: UILabel = {
        let title = UILabel()
        title.text = "ABOUT"
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var calendarTitle: UILabel = {
        let title = UILabel()
        title.text = "TRAVEL DAYS"
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var roadmapTitle: UILabel = {
        let title = UILabel()
        title.text = "ROADMAP"
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var dayTitle: UILabel = {
        let title = UILabel()
        title.text = "Day 1"
        title.stylize(with: designSystem.text.mediumTitle)
        return title
    }()
    
    lazy var budgetView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "budget")
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var budgetLabel: UILabel = {
        let title = UILabel()
        title.text = "DAILY COSTS"
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var budgetValue: UILabel = {
        let title = UILabel()
        title.text = "R$2000.00"
        title.font = designSystem.text.body.font
        title.stylize(with: designSystem.text.body)
        return title
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        btn.setImage(img, for: .normal)
        btn.tintColor = .accent
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var activitiesTableView: UITableView = {
        let table = UITableView()
        table.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = false
        table.backgroundColor = .backgroundPrimary
        return table
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(infoTripCollectionView)
        scrollView.addSubview(calendarCollectionView)
        contentView.addSubview(infoTitle)
        contentView.addSubview(calendarTitle)
        contentView.addSubview(roadmapTitle)
        contentView.addSubview(dayTitle)
        contentView.addSubview(addButton)
        contentView.addSubview(budgetView)
        budgetView.addSubview(budgetLabel)
        budgetView.addSubview(budgetValue)
        scrollView.addSubview(activitiesTableView)
        setupConstraints()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(calendarCollectionView.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        infoTripCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoTitle.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
//            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(100)
        }
        
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)

        }
        
        calendarTitle.snp.makeConstraints { make in
            make.top.equalTo(infoTripCollectionView.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            
        }
        calendarCollectionView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(calendarTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xxLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xxLargePositive)
            make.height.equalTo(60)
        }
        roadmapTitle.snp.makeConstraints { make in
            make.top.equalTo(calendarCollectionView.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        dayTitle.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)

        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(dayTitle.snp.top)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.size.equalTo(40)
        }
        
        budgetView.snp.makeConstraints { make in
            make.top.equalTo(dayTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(40)
            make.trailing.equalTo(budgetValue.snp.trailing).inset(designSystem.spacing.smallNegative)
        }
        
        budgetLabel.snp.makeConstraints { make in
            make.centerY.equalTo(budgetView.snp.centerY)
            make.leading.equalTo(budgetView.snp.leading).inset(designSystem.spacing.smallPositive)
        }
        
        budgetValue.snp.makeConstraints { make in
            make.centerY.equalTo(budgetView.snp.centerY)
            make.leading.equalTo(budgetLabel.snp.trailing).inset(designSystem.spacing.xLargeNegative)
        }
        
        activitiesTableView.snp.makeConstraints { make in
            make.top.equalTo(budgetView.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(400)
        }

    }
}

extension MyTripView {
    func bindCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        infoTripCollectionView.delegate = delegate
        infoTripCollectionView.dataSource = dataSource
        calendarCollectionView.delegate = delegate
        calendarCollectionView.dataSource = dataSource
    }
    func bindTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        activitiesTableView.delegate = delegate
        activitiesTableView.dataSource = dataSource
        
    }

}
