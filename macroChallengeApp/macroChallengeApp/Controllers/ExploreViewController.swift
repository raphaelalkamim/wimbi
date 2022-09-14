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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRoadmap))
    }
    
    @objc
    func addNewRoadmap() {
        coordinator?.newRoadmap()
    }
    
}
