//
//  ReviewTravelViewController.swift
//  macroChallengeApp
//
//  Created by Juliana Santana on 13/09/22.
//

import Foundation
import UIKit

class ReviewTravelView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "beachView")
        image.layer.cornerRadius = 16
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.backgroundColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public lazy var categoryImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.image = UIImage(named: "categoryBeach")
        return image
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = designSystem.palette.titlePrimary
        title.stylize(with: designSystem.text.title)
        title.text = "Fernando de Noronha"
        return title
    }()
    
    public lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.stylize(with: designSystem.text.caption)
        subtitle.textColor = designSystem.palette.textPrimary
        subtitle.text = "Praia"
        return subtitle
    }()
    public lazy var daysTitle: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.caption)
        label.text = "DATE"
        return label
    }()
    public lazy var daysTable: UITableView = {
       let table = UITableView()
        table.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        table.layer.cornerRadius = 16
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = false
        table.backgroundColor = designSystem.palette.backgroundCell
        return table
    }()
    public lazy var travelersTitle: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.caption)
        label.text = "TRAVELERS"
        return label
    }()
    public lazy var travelersTable: UITableView = {
       let table = UITableView()
        table.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        table.layer.cornerRadius = 16
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = false
        table.backgroundColor = designSystem.palette.backgroundCell
        return table
    }()
    public lazy var privacyTitle: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.caption)
        label.text = "PRIVACY"
        return label
    }()
    public lazy var privacyTable: UITableView = {
       let table = UITableView()
        table.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        table.layer.cornerRadius = 16
        table.isScrollEnabled = false
        table.separatorColor = .clear
        table.allowsSelection = false
        table.backgroundColor = designSystem.palette.backgroundCell
        return table
    }()
    
}

extension ReviewTravelView {
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(coverImage)
        contentView.addSubview(categoryImage)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(daysTitle)
        contentView.addSubview(daysTable)
        contentView.addSubview(travelersTitle)
        contentView.addSubview(travelersTable)
        contentView.addSubview(privacyTitle)
        contentView.addSubview(privacyTable)
        
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
            make.bottom.equalTo(privacyTable.snp.bottom).offset(50)
            make.left.right.equalTo(self)
        }
        
        coverImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(150)
        }
        
        categoryImage.snp.makeConstraints { make in
            make.top.equalTo(coverImage.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.height.width.equalTo(64)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(coverImage.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(categoryImage.snp.trailing).inset(designSystem.spacing.xLargeNegative)
            make.height.equalTo(35)
        }
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(categoryImage.snp.trailing).inset(designSystem.spacing.xLargeNegative)
            make.height.equalTo(16)
        }
        daysTitle.snp.makeConstraints { make in
            make.top.equalTo(categoryImage.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        daysTable.snp.makeConstraints { make in
            make.top.equalTo(daysTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(150)
        }
        travelersTitle.snp.makeConstraints { make in
            make.top.equalTo(daysTable.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        travelersTable.snp.makeConstraints { make in
            make.top.equalTo(travelersTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(50)
        }
        privacyTitle.snp.makeConstraints { make in
            make.top.equalTo(travelersTable.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        privacyTable.snp.makeConstraints { make in
            make.top.equalTo(privacyTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.trailing.equalToSuperview().inset(designSystem.spacing.xLargePositive)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(50)
        }
    }
    
    func bindTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        daysTable.delegate = delegate
        daysTable.dataSource = dataSource
        
        travelersTable.delegate = delegate
        travelersTable.dataSource = dataSource
        
        privacyTable.delegate = delegate
        privacyTable.dataSource = dataSource
    }
}
