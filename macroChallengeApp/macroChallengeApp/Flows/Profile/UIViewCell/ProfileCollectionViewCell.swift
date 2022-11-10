//
//  ProfileCollectionViewCell.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 16/09/22.
//

import UIKit
import SnapKit

class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "profileCell"
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(name: "Novo roteiro", image: "beach0", isNew: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.numberOfLines = 2
        title.font = designSystem.text.cellTitle.font
        title.textColor = .textPrimary
        return title
    }()
    
    lazy var roadmapImage: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 16
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return img
    }()
    
    lazy var newTag: UILabel = {
        let tag = UILabel()
        tag.font = UIFont(name: "Avenir-Medium", size: 15)
        tag.textColor = .white
        tag.text = "NEW".localized()
        tag.textAlignment = .center
        tag.layer.masksToBounds = true
        tag.layer.cornerRadius = 10
        tag.backgroundColor = .accent
        return tag
    }()
    
    lazy var likeImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "heart.fill")
        img.tintColor = .titlePrimary
        img.clipsToBounds = true
        return img
    }()
    
    lazy var likeLabel: UILabel = {
        let title = UILabel()
        title.textColor = .textPrimary
        title.font = UIFont(name: "Avenir-Book", size: 12)
        title.text = String(0)
        title.textAlignment = .center
        return title
    }()
}

extension ProfileCollectionViewCell {
    func setup(name: String, image: String, isNew: Bool ) {
        self.addSubview(title)
        self.title.text = name
        
        self.addSubview(roadmapImage)
        self.roadmapImage.image = UIImage(named: image)
        
        self.addSubview(newTag)
        newTag.isHidden = true
        
        if isNew == true { newTag.isHidden = false }
        self.addSubview(likeImage)
        self.addSubview(likeLabel)
        
        setupConstraints()
        
        self.backgroundColor = designSystem.palette.backgroundCell
        self.layer.cornerRadius = 16
        self.title.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupAnchors() {
        if self.title.text!.count < 14 {
            self.title.topAnchor.constraint(equalTo: self.roadmapImage.bottomAnchor, constant: designSystem.spacing.xLargePositive).isActive = true
            self.title.topAnchor.constraint(equalTo: self.roadmapImage.bottomAnchor, constant: designSystem.spacing.smallPositive).isActive = false
        } else {
            self.title.topAnchor.constraint(equalTo: self.roadmapImage.bottomAnchor, constant: designSystem.spacing.xLargePositive).isActive = false
            self.title.topAnchor.constraint(equalTo: self.roadmapImage.bottomAnchor, constant: designSystem.spacing.smallPositive).isActive = true
        }
    }
    
    func setupImage(imageId: String, category: String) {
        if imageId == "defaultCover" {
            self.roadmapImage.image = UIImage(named: "\(imageId)\(category)")
        } else {
            let path = imageId
            let imageNew = UIImage(contentsOfFile: SaveImagecontroller.getFilePath(fileName: path))
            if imageNew == nil {
                if let cachedImage = FirebaseManager.shared.imageCash.object(forKey: NSString(string: path)) {
                    self.roadmapImage.image = cachedImage
                } else {
                    FirebaseManager.shared.getImage(category: 0, uuid: path) { image in
                        self.roadmapImage.image = image
                    }
                }
            } else {
                self.roadmapImage.image = imageNew
            }
        }
    }
    
    func setupConstraints() {
        roadmapImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(98)
        }
        
        newTag.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.height.equalTo(designSystem.spacing.xxLargePositive)
            make.width.equalTo(57)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(designSystem.spacing.smallPositive)
            make.trailing.equalTo(likeLabel.snp.leading).inset(designSystem.spacing.mediumNegative)
        }

        likeImage.snp.makeConstraints { make in
            make.top.equalTo(roadmapImage.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.trailing.equalToSuperview().inset(designSystem.spacing.smallPositive)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(likeImage.snp.bottom).inset(designSystem.spacing.xSmallNegative)
            make.centerX.equalTo(likeImage.snp.centerX)
        }
        
    }
}
