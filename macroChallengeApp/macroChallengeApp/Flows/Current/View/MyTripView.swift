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
    let transparentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.footnote)
        label.textColor = designSystem.palette.textPrimary
        label.textAlignment = .left
        label.text = "02.10.2022"
        return label
    }()
    
    lazy var emptyStateImage: UIImageView = {
        let img = UIImageView()
        img.image = designSystem.images.map
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var emptyStateTitle: UILabel = {
        let title = UILabel()
        title.text = "Click ”+” to add an activity to your day.".localized()
        title.numberOfLines = 0
        title.font = designSystem.text.body.font
        title.textAlignment = .center
        title.textColor = .textPrimary
        return title
    }()
    
    lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.layer.cornerRadius = 20
        view.actualTemperature = "-"
        view.iconTemperature = .weatherCloudSun
        view.rainfallLevel = "-"
        view.higherTemperature = "-"
        view.lowerTemperature =  "-"
        return view
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
    
    lazy var weatherTitle: UILabel = {
        let title = UILabel()
        title.text = "CURRENT WEATHER".localized()
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    lazy var roadmapTitle: UILabel = {
        let title = UILabel()
        title.text = "ITINERARY".localized()
        title.stylize(with: designSystem.text.footnote)
        return title
    }()
    
    lazy var dayTitle: UILabel = {
        let title = UILabel()
        title.text = "Day".localized()
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
        title.text = "DAILY COSTS".localized()
        title.stylize(with: designSystem.text.footnote)
        return title
    }()
    
    lazy var budgetValue: UILabel = {
        let title = UILabel()
        title.text = ""
        title.font = designSystem.text.body.font
        title.stylize(with: designSystem.text.body)
        return title
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        btn.setImage(img, for: .normal)
        btn.tintColor = .accent
        btn.isHidden = true
        return btn
    }()
    
    lazy var activitiesTableView: UITableView = {
        let table = UITableView()
        table.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = true
        table.backgroundColor = designSystem.palette.backgroundPrimary
        table.dragInteractionEnabled = true
        table.isUserInteractionEnabled = true
        return table
    }()

    lazy var tutorialView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tutorialTitle: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "tutorial-left2"), for: .normal)
        return button
    }()
    
    lazy var secondTutorialView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var secondTutorialTitle: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "tutorial-down"), for: .normal)
        return button
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(date)
        scrollView.addSubview(infoTripCollectionView)
        scrollView.addSubview(calendarCollectionView)
        contentView.addSubview(emptyStateImage)
        contentView.addSubview(emptyStateTitle)
        contentView.addSubview(infoTitle)
        contentView.addSubview(weatherTitle)
        contentView.addSubview(weatherView)
        contentView.addSubview(calendarTitle)
        contentView.addSubview(roadmapTitle)
        contentView.addSubview(dayTitle)
        self.addSubview(addButton)
        contentView.addSubview(budgetView)
        budgetView.addSubview(budgetLabel)
        budgetView.addSubview(budgetValue)
        scrollView.addSubview(activitiesTableView)
        scrollView.addSubview(tutorialView)
        tutorialView.isHidden = true
        tutorialView.addSubview(tutorialTitle)
        scrollView.addSubview(secondTutorialView)
        secondTutorialView.isHidden = true
        secondTutorialView.addSubview(secondTutorialTitle)
        activitiesTableView.isHidden = true
        budgetView.isHidden = true
        scrollView.isScrollEnabled = false
        self.addSubview(transparentView)
        transparentView.isHidden = true
        transparentView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        setupConstraints()
    }
    
    func setupContent(roadmap: Roadmap) {
        let formatt = DateFormatter()
        formatt.timeStyle = .none
        formatt.dateStyle = .short
        formatt.dateFormat = "dd/MM/yyyy"
        let dateInitial = formatt.string(from: roadmap.date ?? Date())
        let starts = "Start: ".localized()
        self.date.text = "\(starts)\(dateInitial)"
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
        
        transparentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        date.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
        }
        
        infoTripCollectionView.snp.makeConstraints { make in
            make.top.equalTo(infoTitle.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(100)
        }
        
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(date.snp.bottomMargin).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)

        }
        
        weatherTitle.snp.makeConstraints { make in
            make.top.equalTo(infoTripCollectionView.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        
        weatherView.snp.makeConstraints { make in
            make.top.equalTo(weatherTitle.snp.bottom).offset(designSystem.spacing.mediumPositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(100)
        }
        
        calendarTitle.snp.makeConstraints { make in
            make.top.equalTo(weatherView.snp.bottom).inset(designSystem.spacing.mediumNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            
        }
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarTitle.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xxLargePositive)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(80)
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
        
        emptyStateTitle.snp.makeConstraints { make in
            make.top.equalTo(emptyStateImage.snp.bottom).inset(designSystem.spacing.xxLargeNegative)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(70)
            make.trailing.equalToSuperview().inset(70)

        }
        
        emptyStateImage.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height / 7)
            make.centerX.equalToSuperview()
            make.top.equalTo(dayTitle.snp.bottom).inset(-40)
        }
        
        activitiesTableView.snp.makeConstraints { make in
            make.top.equalTo(budgetView.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(600)
        }
        
        tutorialView.snp.makeConstraints { make in
            make.top.equalTo(activitiesTableView.snp.top).inset(72)
            make.trailing.equalTo(activitiesTableView.snp.trailing).inset(130)
            make.height.equalTo(66)
            make.width.equalTo(131)
        }

        tutorialTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalToSuperview()
            
        }
        
        secondTutorialView.snp.makeConstraints { make in
            make.top.equalTo(activitiesTableView.snp.top).inset(-50)
            make.trailing.equalTo(activitiesTableView.snp.trailing).inset(82)
            make.height.equalTo(70)
            make.width.equalTo(130)
        }
        
        secondTutorialTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalToSuperview()
            
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
    
    func bindTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, dragDelegate: UITableViewDragDelegate) {
        activitiesTableView.delegate = delegate
        activitiesTableView.dataSource = dataSource
        activitiesTableView.dragDelegate = dragDelegate
    }
    func animateCollection(index: Int) {
        infoTripCollectionView.layoutIfNeeded()
        UIView.animate(withDuration: 5,
                       delay: 2,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: [.allowAnimatedContent],
                       animations: { self.infoTripCollectionView.scrollToItem(at: [0, index], at: .right, animated: true) },
                       completion: nil)
    }
    func setEmptyView() {
        if UIDevice.current.name == "iPhone SE (3rd generation)" || UIDevice.current.name == "iPhone 8" {
            emptyStateImage.snp.removeConstraints()
            emptyStateImage.snp.makeConstraints { make in
                make.height.equalTo(UIScreen.main.bounds.height / 9)
                make.centerX.equalToSuperview()
                make.top.equalTo(dayTitle.snp.bottom)
            }
        } else {
            emptyStateImage.snp.removeConstraints()
            emptyStateImage.snp.makeConstraints { make in
                make.height.equalTo(UIScreen.main.bounds.height / 7)
                make.centerX.equalToSuperview()
                make.top.equalTo(dayTitle.snp.bottom).inset(-40)
            }

        }
        activitiesTableView.isHidden = true
        budgetView.isHidden = true
        emptyStateTitle.isHidden = false
        emptyStateImage.isHidden = false
    }
    func setupActivityTable() {
        activitiesTableView.isHidden = false
        budgetView.isHidden = false
        emptyStateTitle.isHidden = true
        emptyStateImage.isHidden = true
        scrollView.isScrollEnabled = true
    }
    func updateConstraintsTable(multiplier: Int) {
        let height = 100 * multiplier
        activitiesTableView.snp.removeConstraints()
        activitiesTableView.snp.makeConstraints { make in
            make.top.equalTo(budgetView.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(height)
        }
    }
}
