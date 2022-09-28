//
//  PreviewRoadmapView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 26/09/22.
//

import Foundation
import UIKit
import SnapKit

class PreviewRoadmapView: UIView {
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
    
    lazy var cover: UIImageView = {
        let img = UIImageView()
        img.image = designSystem.imagesDefault.beach[3]
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.text = "Egito"
        title.stylize(with: designSystem.text.largeTitle)
        return title
    }()
    
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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .backgroundCell
        collection.layer.cornerRadius = 20
        return collection
    }()
    
    lazy var infoTitle: UILabel = {
        let title = UILabel()
        title.text = "SOBRE"
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var calendarTitle: UILabel = {
        let title = UILabel()
        title.text = "DIAS DE VIAGEM"
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var roadmapTitle: UILabel = {
        let title = UILabel()
        title.text = "ROTEIRO"
        title.stylize(with: designSystem.text.caption)
        return title
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
        contentView.addSubview(infoTripCollectionView)
        contentView.addSubview(calendarCollectionView)
        contentView.addSubview(activitiesTableView)
        contentView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(infoTitle)
        contentView.addSubview(calendarTitle)
        contentView.addSubview(roadmapTitle)
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
            make.bottom.equalTo(activitiesTableView)
            make.left.right.equalTo(self)
        }
        
        cover.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).inset(-150)
            make.left.right.equalTo(self)
            make.height.equalTo(270)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)

        }
        
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            
        }
    
        infoTripCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoTitle.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(100)
        }
        
        calendarTitle.snp.makeConstraints { make in
            make.top.equalTo(infoTripCollectionView.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            
        }
        calendarCollectionView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(calendarTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading).inset(40)
            make.trailing.equalTo(contentView.snp.trailing).inset(40)
            make.height.equalTo(40)
        }
        roadmapTitle.snp.makeConstraints { make in
            make.top.equalTo(calendarCollectionView.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        
        activitiesTableView.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(400)
            make.bottom.equalTo(scrollView.snp.bottom)

        }
        
    }
}

extension PreviewRoadmapView {
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