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
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.searchBar = UISearchBar()
        self.searchController = UISearchController()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Where are you want to go?"
        searchBar.sizeToFit()
        return searchBar
    }()
    
    lazy var searchController: UISearchController? = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
        return searchController
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var roadmapsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 350, height: 292)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(RoadmapExploreCollectionViewCell.self, forCellWithReuseIdentifier: RoadmapExploreCollectionViewCell.identifier)
        collectionView.isUserInteractionEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(filterButton)
        contentView.addSubview(roadmapsCollectionView)
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
            make.bottom.equalTo(roadmapsCollectionView.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        roadmapsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(4000)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    func addSearchBarNavigation(navigation: UINavigationItem) {
        navigation.searchController = searchController
        navigation.title = "Explore"
        self.searchController?.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchController(roadmapsSearchTable: UITableViewController) {
        searchController = UISearchController(searchResultsController: roadmapsSearchTable)
        guard let searchController = searchController else { return }
        //        searchController.searchResultsUpdater = roadmapsSearchTable
        searchBar = searchController.searchBar
    }
    
}

extension ExploreView {
    func bindCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        roadmapsCollectionView.delegate = delegate
        roadmapsCollectionView.dataSource = dataSource
    }
    
}
