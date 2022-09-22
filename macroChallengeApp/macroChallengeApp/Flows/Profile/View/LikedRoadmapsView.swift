//
//  LikedRoadmapsView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import SnapKit

class LikedRoadmapsView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let contentView = UIView()
    let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    lazy var likedRoadmapsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
//        layout.itemSize = CGSize(width: 170, height: 165)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .backgroundCell
        collectionView.layer.cornerRadius = 16
        return collectionView
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(likedRoadmapsCollectionView)
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
            make.bottom.equalTo(likedRoadmapsCollectionView.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        likedRoadmapsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(900)
            make.bottom.equalTo(scrollView.snp.bottom)
        }

    }
}
