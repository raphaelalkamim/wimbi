//
//  LabelTableViewCell.swift
//  macroChallengeApp
//
//  Created by Juliana Santana on 14/09/22.
//

import Foundation
import UIKit

class LabelTableViewCell: UITableViewCell {
    static let identifier = "labelCell"
    let designSystem = DefaultDesignSystem.shared

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
    
   public lazy var title: UILabel = {
       let label = UILabel()
       label.stylize(with: designSystem.text.body)
       label.text = "Title"
       return label
    }()
    
    public lazy var value: UILabel = {
        let label = UILabel()
        label.stylize(with: designSystem.text.body)
        label.textColor = designSystem.palette.caption
        label.text = "Value"
        return label
    }()
    
    func setup() {
        contentView.addSubview(title)
        contentView.addSubview(value)
        setupConstraints()
        self.backgroundColor = designSystem.palette.backgroundCell
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
            make.top.equalToSuperview().offset(designSystem.spacing.largeNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.largePositive)
        }
        
        value.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(designSystem.spacing.xSmallNegative)
            make.bottom.equalToSuperview().offset(designSystem.spacing.xSmallPositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.largeNegative)
        }
    }
    func configureDays(indexPath: Int, value: String) {
        if indexPath == 0 {
            self.title.text = "Travel days".localized()
            self.value.text = value
            let separator = UIView()
            self.addSubview(separator)
            separator.backgroundColor = .gray
            
            separator.snp.makeConstraints { make in
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                make.trailing.equalToSuperview()
            }
        }
        if indexPath == 1 {
            self.title.text = "Start date".localized()
            self.value.text = value
            let separator = UIView()
            self.addSubview(separator)
            separator.backgroundColor = .gray
            
            separator.snp.makeConstraints { make in
                make.height.equalTo(0.5)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                make.trailing.equalToSuperview()
            }
        }
        if indexPath == 2 {
            self.title.text = "End date".localized()
            self.value.text = value
        }
    }
    
    func configureTravelers(daysValue: Int) {
        self.title.text = "Number of travelers".localized()
        self.value.text = String(daysValue)
    }
    func configureTripStatus(isPublic: Bool) {
        self.layer.cornerRadius = 16
        self.title.text = "Itinerary".localized()
        if isPublic == true {
            self.value.text = "Public".localized()
        } else {
            self.value.text = "Private".localized()
        }
    }
}
