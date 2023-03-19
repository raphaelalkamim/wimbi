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
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundCell
        self.textLabel?.stylize(with: designSystem.text.body)
        self.detailTextLabel?.stylize(with: designSystem.text.body)
        self.detailTextLabel?.textColor = .caption
    }
    
    func configureDays(indexPath: Int, value: String) {
        if indexPath == 0 {
            self.textLabel?.text = "Travel days".localized()
            self.detailTextLabel?.text = value
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
            self.textLabel?.text = "Start date".localized()
            self.detailTextLabel?.text = value
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
            self.textLabel?.text = "End date".localized()
            self.detailTextLabel?.text = value
        }
    }
    
    func configureTravelers(daysValue: Int) {
        self.textLabel?.text = "Number of travelers".localized()
        self.detailTextLabel?.text = String(daysValue)
    }
    func configureTripStatus(isPublic: Bool) {
        self.layer.cornerRadius = 16
        self.textLabel?.text = "Itinerary".localized()
        if isPublic == true {
            self.detailTextLabel?.text = "Public".localized()
        } else {
            self.detailTextLabel?.text = "Private".localized()
        }
    }
}
