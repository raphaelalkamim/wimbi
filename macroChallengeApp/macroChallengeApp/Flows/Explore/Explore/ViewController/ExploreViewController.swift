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
    var roadmapsMock: [Roadmaps] = []
    let network: NetworkMonitor = NetworkMonitor.shared
    let onboardEnable = UserDefaults.standard.bool(forKey: "onboard")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.startMonitoring()
        explorerView.showSpinner()
        emptyState(conection: network.isReachable)
        
        self.setContextMenu()
        self.locationSearchTable.coordinator = coordinator
        self.setupExplorerView()
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            print(userID)
        }
        if onboardEnable == false {
            coordinator?.startOnboarding()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.startMonitoring()
        DataManager.shared.getPublicRoadmaps({ roadmaps in
            self.roadmaps = roadmaps
            self.roadmaps.sort { $0.likesCount > $1.likesCount }
            if roadmaps.isEmpty { self.getMockData() }
            self.explorerView.roadmapsCollectionView.reloadData()
            self.emptyState(conection: self.network.isReachable)
        })
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    func getMockData() {
        let mockManager = DataMockManager()
        if let localData = mockManager.readLocalFile(forName: "dataRoadmaps") {
            self.roadmapsMock = mockManager.parse(jsonData: localData)!
            self.roadmapsMock.sort { $0.likesCount > $1.likesCount }
            self.explorerView.hiddenSpinner()
        }
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("filtro")
    }
}
