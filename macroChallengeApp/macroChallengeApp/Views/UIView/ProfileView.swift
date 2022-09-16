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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var name: UILabel = {
        let title = UILabel()
        title.text = "Malcon Cardoso" // adicionar nome
        title.stylize(with: designSystem.text.title)
        return title
    }()
    
    private lazy var username: UILabel = {
        let title = UILabel()
        title.text = "@malcon" // adicionar username
        title.stylize(with: designSystem.text.body)
        title.textColor = .caption
        return title
    }()
    
    private lazy var image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "categoryBeach") // adicionar foto de perfil
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var roadmapTitle: UILabel = {
        let title = UILabel()
        title.text = "Meus roteiros" // adicionar nome
        title.stylize(with: designSystem.text.mediumTitle)
        return title
    }()
    
    private lazy var myRoadmapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: 170, height: 165)
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .backgroundPrimary
        return collectionView
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(image)
        contentView.addSubview(name)
        contentView.addSubview(username)
        contentView.addSubview(roadmapTitle)
        contentView.addSubview(myRoadmapCollectionView)
        setupConstraints()
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

        image.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xxLargePositive)
            make.height.size.equalTo(64)
        }

        name.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(image.snp.trailing).inset(designSystem.spacing.largeNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom)
            make.leading.equalTo(image.snp.trailing).inset(designSystem.spacing.largeNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
    
        roadmapTitle.snp.makeConstraints { make in
            make.top.equalTo(username.snp.bottom).inset(-32)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
        }
        
        myRoadmapCollectionView.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)

            make.height.equalTo(900)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
}

extension ProfileView {
    func bindColletionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        myRoadmapCollectionView.delegate = delegate
        myRoadmapCollectionView.dataSource = dataSource
    }
}
