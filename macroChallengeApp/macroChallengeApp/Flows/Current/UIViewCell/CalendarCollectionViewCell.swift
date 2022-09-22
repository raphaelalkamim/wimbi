//
//  CalendarCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 21/09/22.
//

import Foundation
import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "calendarCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var day: UILabel = {
        let title = UILabel()
        title.textColor = .textPrimary
        title.font = UIFont(name: "Avenir-Roman", size: 10)
        title.textAlignment = .center
        title.text = "SUN"
        return title
    }()
    
    lazy var dayButton: UIButton = {
        let btn = UIButton()
//        btn.tintColor = .accent
        btn.setTitle("1", for: .normal)
        btn.layer.cornerRadius = 16
//        btn.backgroundColor = .accent
        btn.setTitleColor(designSystem.palette.textPrimary, for: .normal)
        btn.titleLabel?.font = designSystem.text.infoTitle.font
//        btn.titleLabel?.textColor = .textPrimary
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
}

extension CalendarCollectionViewCell {
    func setup() {
        contentView.addSubview(day)
        contentView.addSubview(dayButton)
        self.layer.cornerRadius = 13
        self.dayButton.addTarget(self, action: #selector(dayAction), for: .touchDown)
        setupConstraints()
        
    }
    
    func setupConstraints() {
        day.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalToSuperview()
        }
        dayButton.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
//            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalTo(day.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(32)
            
        }
        
    }
    
    @objc func dayAction() {
        print("apertei")
        dayButton.backgroundColor = .accent
        dayButton.setTitleColor(.white, for: .normal)
    }
}
