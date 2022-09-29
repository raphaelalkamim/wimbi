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
        
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.shared.getPublicRoadmaps({ roadmaps in
            self.roadmaps = roadmaps
            self.explorerView.roadmapsCollectionView.reloadData()
        })
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    
    @objc func previewRoadmap() {
        coordinator?.previewRoadmap()
    }
    
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("filtro")
    }
}
