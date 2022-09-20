//
//  EditProfileView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 19/09/22.
//

import Foundation
import UIKit
import SnapKit

class NotificationsView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var notificationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationPickerTableViewCell.self, forCellReuseIdentifier: NotificationPickerTableViewCell.identifier)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)

        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .backgroundCell
        tableView.allowsSelection = false
        return tableView
    }()
    
    lazy var descriptionTitle: UILabel = {
        let title = UILabel()
        title.text = "Descrever a notificação"
        title.textColor = .caption
        title.stylize(with: designSystem.text.caption)
        return title
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(contentView)
        self.addSubview(notificationsTableView)
        self.addSubview(descriptionTitle)
        setupConstraints()
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.right.equalTo(self)
        }
        
        notificationsTableView.snp.makeConstraints { make in
            make.leading.equalTo(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(designSystem.spacing.xLargeNegative)
            make.top.equalTo(contentView.snp.topMargin).inset(designSystem.spacing.xSmallPositive)
            make.height.equalTo(230)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.leading.equalTo(designSystem.spacing.xxLargePositive)
            make.trailing.equalTo(designSystem.spacing.xxLargeNegative)
            make.top.equalTo(notificationsTableView.snp.bottom).inset(designSystem.spacing.mediumNegative)
        }
    }
}

extension NotificationsView {
    func bindTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        notificationsTableView.delegate = delegate
        notificationsTableView.dataSource = dataSource
    }
}
