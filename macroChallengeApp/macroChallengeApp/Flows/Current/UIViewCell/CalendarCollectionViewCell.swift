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
        title.text = "SUN".localized()
        return title
    }()
    
    lazy var dayButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("1", for: .normal)
        btn.layer.cornerRadius = 20
        btn.setTitleColor(designSystem.palette.textPrimary, for: .normal)
        btn.titleLabel?.font = designSystem.text.infoTitle.font
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
}

extension CalendarCollectionViewCell {
    func setup() {
        contentView.addSubview(day)
        contentView.addSubview(dayButton)
        self.layer.cornerRadius = 13
        setupConstraints()
        
    }
    
    func setupConstraints() {
        day.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalToSuperview()
        }
        dayButton.snp.makeConstraints { make in
            make.top.equalTo(day.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    func selectedBackgroundView() {
        self.dayButton.backgroundColor = .accent
        self.dayButton.setTitleColor(.white, for: .normal)
    }
    func setDay(date: String) {
        let calendar = Calendar.current
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yy"
        let newDate = format.date(from: date)
                
        let weekday = (calendar.component(.weekday, from: newDate ?? Date()) - calendar.firstWeekday + 7) % 7 + 1
        print(weekday)
        
        format.dateFormat = "d"
        day.text = self.setupDayWeek(day: weekday)
        dayButton.setTitle(format.string(from: newDate ?? Date()), for: .normal)
    }
    func setupDayWeek(day: Int) -> String {
        let weekDays = ["SUN".localized(), "MON".localized(), "TUE".localized(), "WED".localized(), "THU".localized(), "FRI".localized(), "SAT".localized()]
        for integer in 0..<weekDays.count where integer == day {
            return weekDays[integer]
        }
        return "SUN".localized()
    }
   
    @objc func dayAction() {
        print("apertei")
        dayButton.backgroundColor = .accent
        dayButton.setTitleColor(.white, for: .normal)
    }
    func selectedButton() {
        dayButton.backgroundColor = designSystem.palette.accent
        dayButton.setTitleColor(.white, for: .normal)
    }
    func disable() {
        dayButton.backgroundColor = designSystem.palette.backgroundPrimary
        dayButton.setTitleColor(designSystem.palette.textPrimary, for: .normal)
    }
}
