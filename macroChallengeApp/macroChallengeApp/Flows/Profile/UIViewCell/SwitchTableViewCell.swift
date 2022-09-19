//
//  NotificationSwitchTableViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 19/09/22.
//

import Foundation
import UIKit
import SnapKit

class SwitchTableViewCell: UITableViewCell {
    static let identifier = "notificationSwitchCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.stylize(with: designSystem.text.body)
        return title
    }()
    
    lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = .accent
        switchButton.addTarget(self, action: #selector(turnNotification(_:)), for: .valueChanged)
        return switchButton
    }()
    
}

extension SwitchTableViewCell {
    func setup() {
        contentView.addSubview(title)
        contentView.addSubview(switchButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(designSystem.spacing.mediumPositive)
            make.leading.equalToSuperview().inset(designSystem.spacing.largePositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargeNegative)
        }
        switchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(designSystem.spacing.largePositive)
            make.top.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.bottom.equalToSuperview().inset(designSystem.spacing.smallPositive)
        }

    }
    
    @objc func turnNotification(_ sender: UISwitch!) {
        if sender.isOn {
            print("on")
        } else {
            print("off")
        }
    }
}
