//
//  ExploreView.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 23/09/22.
//

import Foundation
import UIKit
import SnapKit

class ExploreView: UIView {
    let designSystem = DefaultDesignSystem.shared
//    let scrollView = UIScrollView()
//    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.searchController = UISearchController()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var searchController: UISearchController? = {
        let searchController = UISearchController()
        return searchController
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
    
    lazy var roadmapsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - designSystem.spacing.xLargePositive, height: 292)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = designSystem.spacing.largePositive
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(RoadmapExploreCollectionViewCell.self, forCellWithReuseIdentifier: RoadmapExploreCollectionViewCell.identifier)
        collectionView.isUserInteractionEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(searchBar)
        self.addSubview(roadmapsCollectionView)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(searchBar)
//        contentView.addSubview(filterButton)
//        contentView.addSubview(roadmapsCollectionView)
        setupConstraints()
    }
    
    func setupConstraints() {
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(self.snp.top)
//            make.bottom.equalTo(self.snp.bottom)
//            make.left.right.equalTo(self)
//        }
//
//        contentView.snp.makeConstraints { make in
//            make.top.equalTo(scrollView.snp.top)
//            make.bottom.equalTo(scrollView.snp.bottom)
//            make.left.right.equalTo(self)
//        }
//
        roadmapsCollectionView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
//            make.height.equalTo(self)
        }
    }
    
    func addSearchBarNavigation(navigation: UINavigationItem) {
        navigation.searchController = searchController
    }
    
    func setupSearchController(locationTable: RoadmapSearchTableViewController) {
        // searchBar
        searchController = UISearchController(searchResultsController: locationTable)
        guard let searchController = searchController else {
            return
        }
        
        searchController.searchResultsUpdater = locationTable
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
        
        searchBar = searchController.searchBar
        searchBar.placeholder = "Para onde você vai?"
    }
}

extension ExploreView {
    func bindCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        roadmapsCollectionView.delegate = delegate
        roadmapsCollectionView.dataSource = dataSource
    }
    
}