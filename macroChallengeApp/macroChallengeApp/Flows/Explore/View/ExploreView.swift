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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.searchController = UISearchController()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var emptyStateTitle: UILabel = {
        let title = UILabel()
        title.text = "No internet connection".localized()
        title.numberOfLines = 0
        title.font = designSystem.text.body.font
        title.textAlignment = .center
        title.textColor = .textPrimary
        return title
    }()
    
    lazy var emptyStateImage: UIImageView = {
        let img = UIImageView()
        img.image = designSystem.images.lostConnection
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
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
    
    lazy var activity: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()
    
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(searchBar)
        self.addSubview(roadmapsCollectionView)
        self.addSubview(emptyStateImage)
        self.addSubview(emptyStateTitle)
        emptyStateTitle.isHidden = true
        emptyStateImage.isHidden = true
        setupConstraints()
    }
    
    func setupConstraints() {
        roadmapsCollectionView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview()
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        emptyStateTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStateImage.snp.bottom).inset(designSystem.spacing.xLargeNegative)

        }
        emptyStateImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.top.equalToSuperview().inset(330)

        }
    }
    func showSpinner() {
        activity.color = designSystem.palette.accent
        activity.startAnimating()
        self.addSubview(activity)
        activity.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    func hiddenSpinner() {
        activity.removeFromSuperview()
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
        
        // Filtro
//        searchController.searchBar.showsBookmarkButton = true
//        searchController.searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
        
        searchBar = searchController.searchBar
        searchBar.placeholder = "Where do you want to go?".localized()
    }
}

extension ExploreView {
    func bindCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        roadmapsCollectionView.delegate = delegate
        roadmapsCollectionView.dataSource = dataSource
    }
    
}
