//
//  ExploreView.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 23/09/22.
//

import Foundation
import UIKit

class ExploreView: UIView {
    let designSystem = DefaultDesignSystem.shared
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.searchBar = UISearchBar()
        self.searchController = UISearchController()
        setup()
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
        let collectionView = UICollectionView()
        return collectionView
    }()
}

extension ExploreView {
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
    }
    
    func addSearchBarNavigation(navigation:UINavigationItem) {
        navigation.searchController = searchController
        navigation.title = "Explorer"
        self.searchController?.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchController(roadmapsSearchTable: UITableViewController) {
        searchController = UISearchController(searchResultsController: roadmapsSearchTable)
        guard let searchController = searchController else { return }
        //searchController.searchResultsUpdater = roadmapsSearchTable
        searchBar = searchController.searchBar
    }
}


