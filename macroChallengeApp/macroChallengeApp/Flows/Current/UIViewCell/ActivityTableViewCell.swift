//
//  ActivityCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 22/09/22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ActivityTableViewCell: UITableViewCell {
    static let identifier = "activityCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let myTripViewController = MyTripViewController()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var activityIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "leisure")
        icon.clipsToBounds = true
        return icon
    }()
    
    lazy var activityInfo: UILabel = {
        let title = UILabel()
        title.stylize(with: designSystem.text.caption)
        title.textColor = .textPrimary
        title.text = "08h00  •  Grátis"
        return title
    }()
    
    lazy var activityTitle: UILabel = {
        let title = UILabel()
        title.stylize(with: designSystem.text.cellTitle)
        title.textColor = .textPrimary
        title.text = "Praia Lopes Mendes"
        return title
    }()
    
    lazy var localButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        btn.tintColor = .accent
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
}

extension ActivityTableViewCell {
    func setup() {
        contentView.addSubview(activityIcon)
        contentView.addSubview(activityInfo)
        contentView.addSubview(activityTitle)
        contentView.addSubview(localButton)
        self.backgroundColor = .backgroundPrimary
        setupConstraints()
        
    }
    func setupDaysActivities(hour: String, value: String, name: String) {
        let hour = hour
        self.activityInfo.text = hour + " • " + "R$" + value
        self.activityTitle.text = name
    }
    func setupConstraints() {
        activityIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
            
        }
        
        activityInfo.snp.makeConstraints { make in
            make.leading.equalTo(activityIcon.snp.trailing).inset(designSystem.spacing.xLargeNegative)
            make.top.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
        }
        
        activityTitle.snp.makeConstraints { make in
            make.leading.equalTo(activityIcon.snp.trailing).inset(designSystem.spacing.xLargeNegative)
            make.top.equalTo(activityInfo.snp.bottom)
        }

        localButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(designSystem.spacing.xxLargePositive)
            make.centerY.equalToSuperview().inset(designSystem.spacing.smallNegative)
            
        }

    }
    
}
