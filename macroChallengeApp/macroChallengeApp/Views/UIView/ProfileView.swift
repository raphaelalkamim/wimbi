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
        title.numberOfLines = 0
        title.textColor = .textPrimary
        title.font = designSystem.text.title.font
        title.backgroundColor = .systemOrange
        return title
    }()
    
    private lazy var username: UILabel = {
        let title = UILabel()
        title.text = "@malco" // adicionar username
        title.numberOfLines = 0
        title.textColor = .caption
        title.font = designSystem.text.body.font
        title.backgroundColor = .systemCyan
        return title
    }()
    
    private lazy var image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "categoryBeach") // adicionar foto de perfil
        img.clipsToBounds = true
        img.backgroundColor = .systemMint
        return img
    }()
    
    private lazy var roadmapTitle: UILabel = {
        let title = UILabel()
        title.text = "Meus " // adicionar nome
        title.numberOfLines = 0
        title.textColor = .textPrimary
        title.font = designSystem.text.largeTitle.font
        title.backgroundColor = .systemPink
        return title
    }()
    
    private lazy var roadmapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 20)
        //        layout.itemSize = CGSize(width: 165, height: 220)
        // width 165, height 250
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.identifier)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.backgroundColor = .green
        contentView.backgroundColor = .orange
        scrollView.addSubview(contentView)
        contentView.addSubview(image)
        contentView.addSubview(name)
        contentView.addSubview(username)
        contentView.addSubview(roadmapTitle)
        contentView.addSubview(roadmapCollectionView)
        setupConstraints()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
            make.left.right.equalTo(self)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
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
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargeNegative)
        }
        
        username.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom)
            make.leading.equalTo(image.snp.trailing).inset(designSystem.spacing.largeNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargeNegative)
        }
    
        roadmapTitle.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).inset(-32)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xxLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xxLargePositive)
        }
        
        roadmapCollectionView.snp.makeConstraints { make in
            make.top.equalTo(roadmapTitle.snp.bottom).inset(designSystem.spacing.xxLargeNegative)
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.leading.equalTo(contentView.snp.leading).inset(20)

            make.height.equalTo(1000)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
}

extension ProfileView {
    func bindColletionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        roadmapCollectionView.delegate = delegate
        roadmapCollectionView.dataSource = dataSource
    }
}
