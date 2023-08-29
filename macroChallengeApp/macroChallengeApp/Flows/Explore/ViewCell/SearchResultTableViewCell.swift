//
//  searchResultTableViewCell.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 28/09/22.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let identifier = "ResultCell"
    
    lazy var cover: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptySearch")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.stylize(with: designSystem.text.headline)
        return label
    }()
    
    lazy var caption: UILabel = {
        let label = UILabel()
        label.text = ""
        label.stylize(with: designSystem.text.footnote)
        return label
    }()
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundCell
        contentView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(caption)
        backgroundColor = designSystem.palette.backgroundPrimary
        setupConstraints()
    }
    
    func setupConstraints() {
        cover.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(designSystem.spacing.mediumPositive)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(cover.snp.trailing).inset(designSystem.spacing.largeNegative)
            make.top.equalToSuperview().inset(designSystem.spacing.mediumPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.mediumNegative)
        }
        
        caption.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.leading.equalTo(title.snp.leading)
            make.trailing.equalTo(title.snp.trailing)
        }
    }
    
    func setupContent(roadmap: RoadmapDTO) {
        var amount = "per person".localized()
           var cost = ""
           var travelers = ""
           var days = ""
           if roadmap.peopleCount == 1 {
               travelers = "traveler  •".localized()
           } else {
               travelers = "travelers  •".localized()
           }
           if roadmap.dayCount == 1 {
               days = "day".localized()
           } else {
               days = "days".localized()
           }
           
           if (Int(roadmap.budget) / roadmap.peopleCount) > 1000 {
               amount = "thousand per person".localized()
               cost = " •  \(roadmap.currency) \(String(format: "%.2f", roadmap.budget / Double(roadmap.peopleCount) / 1000)) \(amount)"
           } else {
               cost = " •  \(roadmap.currency) \(String(format: "%.2f", roadmap.budget / Double(roadmap.peopleCount))) \(amount)"
           }
           self.caption.text = "\(roadmap.peopleCount) \(travelers)  \(roadmap.dayCount) \(days) \(cost)"

       }
    
    func setupImage(category: String) -> String {
        return String("\(category)Cover")
    }
}
