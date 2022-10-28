//
//  SettingsCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 17/09/22.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "settingsCell"
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
    
    lazy var icon: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .small))
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .accent
        btn.layer.cornerRadius = 8
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var chevron: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "chevron.forward")
        img.clipsToBounds = true
        img.tintColor = .caption
        return img
    }()
}

extension SettingsTableViewCell {
    func setup() {
        self.addSubview(title)
        self.addSubview(icon)
        self.addSubview(chevron)
        self.selectionStyle = .none
        setupConstraints()
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(designSystem.spacing.mediumPositive)
            make.leading.equalTo(icon.snp.trailing).inset(designSystem.spacing.largeNegative)
            make.trailing.equalToSuperview().inset(designSystem.spacing.xLargeNegative)
        }
        
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.largePositive)
            make.bottom.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.size.equalTo(30)
        }
        
        chevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(designSystem.spacing.largePositive)
            make.top.equalToSuperview().inset(designSystem.spacing.mediumPositive)
        }
        
    }
}
