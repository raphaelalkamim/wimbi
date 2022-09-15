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
    
    private let newRoadmap = NewRoadmapCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        newRoadmap.start()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRoadmap))
    }
    
    @objc
    func addNewRoadmap() {
        let newVc = newRoadmap.navigationController
        UIApplication.shared.windows.first!.rootViewController = newVc
    }
    
}
