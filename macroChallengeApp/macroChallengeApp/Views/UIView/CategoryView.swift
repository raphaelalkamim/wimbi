//
//  CategoryView.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 12/09/22.
//

import Foundation
import UIKit
import SnapKit

class CategoryView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let horizontalInset: CGFloat = 0
    lazy var verticalInset: CGFloat = {
        var size = CGFloat()
        size = designSystem.spacing.xxLargePositive
        return size
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(
           top: verticalInset,
           left: horizontalInset,
           bottom: verticalInset,
           right: horizontalInset)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = 80.0
        let width = collectionView.frame.width
        let itemSize = CGSize(width: width, height: height)
        flowLayout.itemSize = itemSize
    }
}

extension CategoryView {
    func setup() {
        self.addSubview(collectionView)
        setupConstraints()
    }
    
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func bindColletionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
}
