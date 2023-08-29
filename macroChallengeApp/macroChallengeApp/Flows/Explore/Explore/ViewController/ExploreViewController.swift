//
//  ViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 02/09/22.
//

import UIKit
import Network

protocol RoadmapSearchTableDidUpdateRoadmaps: AnyObject {
    func updateRoadmaps(roadmaps: [RoadmapDTO])
}

class ExploreViewController: UIViewController {
    weak var coordinator: ExploreCoordinator?
    weak var delegate:RoadmapSearchTableDidUpdateRoadmaps?
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let locationSearchTable = RoadmapSearchTableViewController()
    let currencyController = CurrencyController()

    let explorerView = ExploreView()
    var roadmaps: [RoadmapDTO] = []
    var roadmapsMock: [Roadmaps] = []
    let network: NetworkMonitor = NetworkMonitor.shared
    let onboardEnable = UserDefaults.standard.bool(forKey: "onboard")
    
    lazy var userCurrency: String = {
        let userC = currencyController.getUserCurrency()
        return userC
    }()
    
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
        
        self.delegate = locationSearchTable
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.startMonitoring()
        DataManager.shared.getPublicRoadmaps({ roadmaps in
            self.roadmaps = roadmaps
            self.roadmaps.sort { $0.likesCount > $1.likesCount }
            if roadmaps.isEmpty { self.getMockData() }
            self.emptyState(conection: self.network.isReachable)
            self.filterRoadmapsToAppear()
        })
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    
    func filterRoadmapsToAppear() {
        var filteredRoadmaps: [RoadmapDTO] = []
        for roadmap in roadmaps.indices {
            if !(roadmaps[roadmap].budget == 0.0) {
                filteredRoadmaps.append(roadmaps[roadmap])
            }
        }
        self.roadmaps = filteredRoadmaps
        self.delegate?.updateRoadmaps(roadmaps: filteredRoadmaps)
        self.explorerView.roadmapsCollectionView.reloadData()
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            FirebaseManager.shared.createAnalyticsEvent(event: "search_roadmap", parameters: ["search_text": searchText])
        }
    }
}
