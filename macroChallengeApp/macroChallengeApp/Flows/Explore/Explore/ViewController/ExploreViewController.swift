//
//  ViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 02/09/22.
//

import UIKit

class ExploreViewController: UIViewController {
    weak var coordinator: ExploreCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let locationSearchTable = RoadmapSearchTableViewController()
    
    let explorerView = ExploreView()
    var roadmaps: [RoadmapDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setContextMenu()
    
        self.locationSearchTable.coordinator = coordinator
        self.setupExplorerView()
        explorerView.setupSearchController(locationTable: locationSearchTable)
        explorerView.bindCollectionView(delegate: self, dataSource: self)
        explorerView.addSearchBarNavigation(navigation: navigationItem)
        
        explorerView.searchBar.delegate = self
        emptyState()
        definesPresentationContext = true
        
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            print(userID)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.shared.getPublicRoadmaps({ roadmaps in
            self.roadmaps = roadmaps
            self.explorerView.roadmapsCollectionView.reloadData()
            self.emptyState()
        })
        navigationController?.navigationBar.prefersLargeTitles = true
        emptyState()
    }
    
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    
    func emptyState() {
        if roadmaps.isEmpty {
            explorerView.roadmapsCollectionView.isHidden = true
            explorerView.emptyStateTitle.isHidden = false
            explorerView.emptyStateImage.isHidden = false
            explorerView.roadmapsCollectionView.isScrollEnabled = false
        } else {
            explorerView.roadmapsCollectionView.isHidden = false
            explorerView.emptyStateTitle.isHidden = true
            explorerView.emptyStateImage.isHidden = true
            explorerView.roadmapsCollectionView.isScrollEnabled = true
        }
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("filtro")
    }
}
