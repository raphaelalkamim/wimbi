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
        
        
        explorerView.bindCollectionView(delegate: self, dataSource: self)
        self.setContextMenu()
        self.setupExplorerView()
    }
    
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    
    @objc func previewRoadmap() {
        coordinator?.previewRoadmap()
    }
    
}
