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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRoadmap))
        self.setupExplorerView()
        explorerView.bindCollectionView(delegate: self, dataSource: self)
    }
    
    @objc
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    
}
