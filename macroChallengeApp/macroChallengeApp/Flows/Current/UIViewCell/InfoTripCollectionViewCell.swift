//
//  InfoTripCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import UIKit

class InfoTripCollectionViewCell: UICollectionViewCell {
    static let identifier = "infoCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    lazy var userCurrency: String = {
        let userC = self.getUserCurrency()
        return userC
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.stylize(with: designSystem.text.footnote)
        title.textColor = .textPrimary
        title.textAlignment = .center
        title.text = ""
        return title
    }()
    
    lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .caption
        return separator
    }()
    
    lazy var infoTitle: UILabel = {
        let title = UILabel()
        title.textColor = .textPrimary
        title.font = designSystem.text.smallTitle.font
        title.textAlignment = .center
        title.text = ""
        return title
    }()
    
    lazy var info: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        btn.setImage(img, for: .normal)
        btn.tintColor = .textPrimary
        btn.setTitle("", for: .normal)
        btn.setTitleColor(designSystem.palette.textPrimary, for: .normal)
        btn.titleLabel?.font = designSystem.text.smallTitle.font
        //        btn.titleLabel?.textColor = .textPrimary
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var circle: UIImageView = {
        let circle = UIImageView()
        circle.backgroundColor = .redCity
        circle.layer.cornerRadius = 12
        return circle
    }()
    
    lazy var categoryTitle: UILabel = {
        let title = UILabel()
        title.stylize(with: designSystem.text.smallCaption)
        title.textAlignment = .center
        title.textColor = .textPrimary
        title.text = ""
        return title
    }()
    func setupContentCell(roadmap: Roadmap, indexPath: Int, userCurrency: String, uuidImage: String) {
        switch indexPath {
        case 0:
            setupCategory(category: roadmap.category)
        case 1:
            setupTotalAmount(userCurrency: userCurrency, budget: roadmap.budget)
        case 2:
            setupTravelers(peopleCount: roadmap.peopleCount)
        case 3:
            setupLikes(likesCount: roadmap.likesCount)
        case 4:
            setupCreatedBy()
            if let cachedImage = FirebaseManager.shared.imageCash.object(forKey: NSString(string: uuidImage)) {
                circle.image = cachedImage
            } else { circle.image = UIImage(named: "icon") }
        default:
            break
        }
    }
    func setupContent(roadmap: RoadmapLocal, indexPath: Int, user: UserLocal) {
        switch indexPath {
        case 0:
            setupCategory(category: roadmap.category ?? "Mountain")
        case 1:
            setupTotalAmount(userCurrency: userCurrency, budget: roadmap.budget)
        case 2:
            setupTravelers(peopleCount: Int(roadmap.peopleCount))
        case 3:
            if roadmap.isPublic == true {
                setupLikes(likesCount: Int(roadmap.likesCount))
            } else {
                setupPrivate()
                
            }
        case 4:
            setupCreatedBy()
            self.setupImage(userId: user.photoId ?? "icon")
        default:
            break
        }
    }
    func setupCircleColor(category: String) {
        if category == "Countryside" {
            circle.backgroundColor = designSystem.palette.greenCamp
        } else if category == "Beach" {
            circle.backgroundColor = designSystem.palette.blueBeach
        } else if category == "City" {
            circle.backgroundColor = designSystem.palette.redCity
        } else {
            circle.backgroundColor = designSystem.palette.yellowMontain
        }
    }
    
    func getUserCurrency() -> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        return currencySymbol ?? "$"
    }
    func setupCategory(category: String) {
        title.text = "CATEGORY".localized()
        circle.isHidden = false
        categoryTitle.isHidden = false
        categoryTitle.text = category.localized()
        setupCircleColor(category: category)
        info.isHidden = true
        circle.snp.makeConstraints { make in make.height.width.equalTo(24) }
    }
    func setupTotalAmount(userCurrency: String, budget: Double) {
        title.text = "TOTAL AMOUNT".localized()
        info.isHidden = true
        infoTitle.isHidden = false
        circle.isHidden = true
        categoryTitle.isHidden = true
        let content = String(format: "\(userCurrency)%.2f", budget)
        infoTitle.text = content
    }
    func setupTravelers(peopleCount: Int) {
        title.text = "TRAVELERS".localized()
        info.isHidden = false
        infoTitle.isHidden = true
        info.setTitle(" \(peopleCount)", for: .normal)
        info.setImage(UIImage(systemName: "person.fill"), for: .normal)
    }
    func setupLikes(likesCount: Int) {
        title.text = "LIKES".localized()
        categoryTitle.isHidden = true
        circle.isHidden = true
        infoTitle.isHidden = true
        info.isHidden = false
        info.setTitle(" \(likesCount)", for: .normal)
    }
    
    func setupPrivate() {
        title.text = "LIKES".localized()
        circle.isHidden = true
        infoTitle.isHidden = true
        info.isHidden = false
        let img = UIImage(systemName: "lock.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        info.setImage(img, for: .normal)
        categoryTitle.isHidden = false
        categoryTitle.text = "Private itinerary".localized()
        categoryTitle.snp.removeConstraints()
        categoryTitle.snp.makeConstraints { make in
            make.top.equalTo(info.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.centerX.equalToSuperview()
        }

    }
    
    func setupCreatedBy() {
        title.text = "CREATED BY".localized()
        separator.isHidden = true
        circle.isHidden = false
        info.isHidden = true
        circle.layer.cornerRadius = 18
        circle.clipsToBounds = true
        circle.snp.makeConstraints { make in make.height.width.equalTo(36) }
    }
}

extension InfoTripCollectionViewCell {
    func setup() {
        contentView.addSubview(title)
        contentView.addSubview(info)
        contentView.addSubview(infoTitle)
        contentView.addSubview(separator)
        contentView.addSubview(circle)
        contentView.addSubview(categoryTitle)
        self.backgroundColor = .backgroundPrimary
        self.layer.cornerRadius = 13
        infoTitle.isHidden = true
        circle.isHidden = true
        categoryTitle.isHidden = true
        setupConstraints()
    }
    
    func setupImage(userId: String) {
        let path = userId
        let imageNew = UIImage(contentsOfFile: SaveImagecontroller.getFilePath(fileName: path))
        circle.image = imageNew
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 18
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.top.equalToSuperview().inset(designSystem.spacing.smallPositive)
        }
        info
            .snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
                make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
                make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.mediumNegative)
            }
        
        infoTitle
            .snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
                make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
                make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.mediumNegative)
            }
        
        separator.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing)
            make.centerY.equalToSuperview()
            make.top.equalTo(contentView.snp.topMargin).inset(designSystem.spacing.xSmallPositive)
            make.bottom.equalTo(contentView.snp.bottomMargin).inset(designSystem.spacing.xSmallPositive)
            make.width.equalTo(0.5)
        }
        
        circle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.centerX.equalToSuperview()
        }
        
        categoryTitle.snp.makeConstraints { make in
            make.top.equalTo(circle.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.centerX.equalToSuperview()
        }
        
    }
}
