//
//  ProfileView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 15/09/22.
//

import Foundation
import UIKit
import SnapKit

class ProfileView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let scrollView = UIScrollView()
    let contentView = UIView()
    var roadmaps = RoadmapRepository.shared.getRoadmap()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var name: UILabel = {
        let title = UILabel()
        title.text = "User".localized() // adicionar nome
        title.stylize(with: designSystem.text.title)
        return title
    }()
    
    private lazy var username: UILabel = {
        let title = UILabel()
        title.text = "@user".localized() // adicionar username
        title.stylize(with: designSystem.text.body)
        title.textColor = .caption
        return title
    }()
    
    private lazy var userImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon") // adicionar foto de perfil
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var roadmapTitle: UILabel = {
        let title = UILabel()
        title.text = "My roadmaps".localized() // adicionar nome
        title.stylize(with: designSystem.text.mediumTitle)
        return title
    }()
    
    lazy var emptyStateTitle: UILabel = {
        let title = UILabel()
        title.text = "Click on ”+” to create a new roadmap or to explore the existing ones.".localized()
        title.numberOfLines = 0
        title.font = designSystem.text.body.font
        title.textAlignment = .center
        title.textColor = .textPrimary
        return title
    }()
    
    lazy var emptyStateImage: UIImageView = {
        let img = UIImageView()
        img.image = designSystem.images.binoculars
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
        
    lazy var addButton: UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        btn.setImage(img, for: .normal)
        btn.tintColor = .accent
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var myRoadmapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2.1 - designSystem.spacing.xLargePositive, height: 165)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .backgroundPrimary
        return collectionView
    }()
    
    func emptyState() {
        if RoadmapRepository.shared.getRoadmap().isEmpty {
            myRoadmapCollectionView.isHidden = true
            emptyStateTitle.isHidden = false
            emptyStateImage.isHidden = false
            scrollView.isScrollEnabled = false
        } else {
            myRoadmapCollectionView.isHidden = false
            emptyStateTitle.isHidden = true
            emptyStateImage.isHidden = true
            scrollView.isScrollEnabled = true
        }
    }
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(userImage)
        contentView.addSubview(name)
        contentView.addSubview(username)
        contentView.addSubview(roadmapTitle)
        contentView.addSubview(addButton)
        contentView.addSubview(myRoadmapCollectionView)
        contentView.addSubview(emptyStateTitle)
        contentView.addSubview(emptyStateImage)
        emptyStateTitle.isHidden = true
        emptyStateImage.isHidden = true
        setupConstraints()
        emptyState()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.right.equalTo(self)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(myRoadmapCollectionView.snp.bottom)
            make.left.right.equalTo(self)
        }

        userImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xxLargePositive)
            make.height.size.equalTo(64)
        }

        name.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(userImage.snp.trailing).inset(designSystem.spacing.largeNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom)
            make.leading.equalTo(userImage.snp.trailing).inset(designSystem.spacing.largeNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
    
        roadmapTitle.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).inset(-32)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.top)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.size.equalTo(40)
        }
        
        myRoadmapCollectionView.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        emptyStateTitle.snp.makeConstraints { make in
            make.top.equalTo(emptyStateImage.snp.bottom).inset(designSystem.spacing.xLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(40)
            make.trailing.equalTo(contentView.snp.trailing).inset(40)

        }
        emptyStateImage.snp.makeConstraints { make in
//            make.top.equalTo(roadmapTitle.snp.bottom).inset(-UIScreen.main.bounds.height / 7)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(48)
            make.height.equalTo(100)
        }
    }
    
    func updateConstraintsCollection() {
        var heightCollection = 180
        let roadmapProfile = roadmaps.count
        
        if roadmapProfile.isMultiple(of: 2) { // par
            heightCollection = (roadmapProfile / 2) * 180
        } else { // impar
            heightCollection = ((roadmapProfile + 1) / 2) * 180
        }
        
        myRoadmapCollectionView.snp.removeConstraints()
        myRoadmapCollectionView.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(heightCollection)
        }
        
    }
    
    func getTable() -> UICollectionView {
        return myRoadmapCollectionView
    }
    
    func getName() -> UILabel {
        return name
    }
    
    func getUsernameApp() -> UILabel {
        return username
    }
    
    func getImage() -> UIImageView {
        userImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xxLargePositive)
            make.height.size.equalTo(64)
        }
        userImage.layer.cornerRadius = 32
        return userImage
    }
    
}

extension ProfileView {
    func bindColletionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        myRoadmapCollectionView.delegate = delegate
        myRoadmapCollectionView.dataSource = dataSource
    }
}
