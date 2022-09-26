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
    let explorerView = ExploreView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        
        let addRoadMap = UIAction(title: "New Trip") { (action) in
            self.addNewRoadmap()
            print("Users action was tapped")
        }
        
        let insertRoadMap = UIAction(title: "Existing Trip") { (action) in
            
            print("Add User action was tapped")
        }
        
        
        let menuBarButton = UIBarButtonItem(
            title: "Add",
            image: UIImage(systemName:"plus"),
            primaryAction: nil,
            menu: UIMenu(title: "", children: [addRoadMap, insertRoadMap])
        )
        
        self.navigationItem.rightBarButtonItem = menuBarButton
        self.setupExplorerView()
        explorerView.bindCollectionView(delegate: self, dataSource: self)
    }
    
    @objc func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    
    @objc func previewRoadmap() {
        coordinator?.previewRoadmap()
    }
    
}
