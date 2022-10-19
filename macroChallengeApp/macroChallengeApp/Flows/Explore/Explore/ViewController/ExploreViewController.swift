//
//  ViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 02/09/22.
//

import UIKit
import Network

class ExploreViewController: UIViewController {
    weak var coordinator: ExploreCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let locationSearchTable = RoadmapSearchTableViewController()
    
    let explorerView = ExploreView()
    var roadmaps: [RoadmapDTO] = []
    let network: NetworkMonitor = NetworkMonitor.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        network.startMonitoring()
        explorerView.showSpinner()
        emptyState(conection: network.isReachable)
        
        self.view.backgroundColor = .backgroundPrimary
        self.setContextMenu()
    
        self.locationSearchTable.coordinator = coordinator
        self.setupExplorerView()
        explorerView.setupSearchController(locationTable: locationSearchTable)
        explorerView.bindCollectionView(delegate: self, dataSource: self)
        explorerView.addSearchBarNavigation(navigation: navigationItem)
        
        explorerView.searchBar.delegate = self
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.shared.getPublicRoadmaps({ roadmaps in
            self.roadmaps = roadmaps
            self.explorerView.roadmapsCollectionView.reloadData()
            self.emptyState(conection: self.network.isReachable)
        })
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    
    func emptyState(conection: Bool) {
        if conection {
            self.explorerView.roadmapsCollectionView.isHidden = false
            self.explorerView.emptyStateTitle.isHidden = true
            self.explorerView.emptyStateImage.isHidden = true
            self.explorerView.roadmapsCollectionView.isScrollEnabled = true
            if !self.roadmaps.isEmpty {
                self.explorerView.hiddenSpinner()
            }
        } else {
            self.explorerView.hiddenSpinner()
            self.explorerView.roadmapsCollectionView.isHidden = true
            self.explorerView.emptyStateTitle.isHidden = false
            self.explorerView.emptyStateImage.isHidden = false
            self.explorerView.roadmapsCollectionView.isScrollEnabled = false
        }
        self.network.stopMonitoring()
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("filtro")
    }
}
