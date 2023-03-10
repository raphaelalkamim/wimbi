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
    let transparentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.setupLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cover: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "")
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false 
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.text = ""
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
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .backgroundPrimary
        return collection
    }()
    
    lazy var emptyStateTitle: UILabel = {
        let title = UILabel()
        title.text = "Nenhuma atividade programada para este dia.".localized()
        title.numberOfLines = 0
        title.font = designSystem.text.body.font
        title.textAlignment = .center
        title.textColor = .textPrimary
        return title
    }()
    
    lazy var infoTitle: UILabel = {
        let title = UILabel()
        title.text = "ABOUT".localized()
        title.stylize(with: designSystem.text.footnote)
        return title
    }()
    
    lazy var calendarTitle: UILabel = {
        let title = UILabel()
        title.text = "TRAVEL DAYS".localized()
        title.stylize(with: designSystem.text.footnote)
        return title
    }()
    
    lazy var roadmapTitle: UILabel = {
        let title = UILabel()
        title.text = "ITINERARY".localized()
        title.stylize(with: designSystem.text.footnote)
        return title
    }()
    
    lazy var activitiesTableView: UITableView = {
        let table = UITableView()
        table.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = true
        table.backgroundColor = .backgroundPrimary
        return table
    }()
    
    lazy var tutorialView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tutorialTitle: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "tutorial-right"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    lazy var activity: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()
    lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = designSystem.palette.backgroundPrimary
        return view
    }()
    
    lazy var username: UILabel = {
        let title = UILabel()
        title.text = "@wimbi"
        title.stylize(with: designSystem.text.body)
        return title
    }()
    
    func setupLoad() {
        showSpinner()
    }
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        self.addSubview(transparentView)
        transparentView.isHidden = true
        transparentView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        contentView.addSubview(infoTripCollectionView)
        contentView.addSubview(calendarCollectionView)
        contentView.addSubview(activitiesTableView)
        contentView.addSubview(cover)
        cover.layer.cornerRadius = 16
        contentView.addSubview(title)
        contentView.addSubview(infoTitle)
        contentView.addSubview(calendarTitle)
        contentView.addSubview(roadmapTitle)
        contentView.addSubview(username)
        contentView.addSubview(tutorialView)
        contentView.addSubview(emptyView)
        contentView.addSubview(emptyStateTitle)
        emptyStateTitle.isHidden = true
        tutorialView.isHidden = true
        tutorialView.addSubview(tutorialTitle)
        setupConstraints()
    }
    
    func emptyState(activities: [Activity]) {
        if activities.isEmpty {
            activitiesTableView.isHidden = true
            emptyStateTitle.isHidden = false
            scrollView.isScrollEnabled = false
        } else {
            activitiesTableView.isHidden = false
            emptyStateTitle.isHidden = true
            scrollView.isScrollEnabled = true
        }
    }
    
    func setupConstraints() {
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
        }
        transparentView.snp.makeConstraints { make in
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
            make.top.equalTo(scrollView.snp.top).inset(16)
            make.left.right.equalTo(self).inset(16)
            make.height.equalTo(200)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            
        }
        
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).inset(designSystem.spacing.mediumNegative)
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
            make.top.equalTo(calendarTitle.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xxLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xxLargePositive)
            make.height.equalTo(80)
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
            make.height.equalTo(900)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        tutorialView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(80)
            make.width.equalTo(160)
        }

        tutorialTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            
        }
        
        emptyStateTitle.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.bottom).inset(designSystem.spacing.xxLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            
        }
    }
    
    func showSpinner() {
        activity.color = designSystem.palette.accent
        activity.startAnimating()
        self.addSubview(activity)
        activity.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    func hiddenSpinner() {
        emptyView.isHidden = true
        activity.removeFromSuperview()
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
    func animateCollection() {
        infoTripCollectionView.layoutIfNeeded()
        UIView.animate(withDuration: 5,
                       delay: 1,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { self.infoTripCollectionView.scrollToItem(at: [0, 2], at: .right, animated: true) },
                       completion: nil)
        infoTripCollectionView.reloadData()
    }
}
