//
//  CurrentCoordinator.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

class CurrentCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        let viewController = CurrentViewController()
        viewController.coordinator = self
        let tabBarItem = UITabBarItem(title: "Current".localized(), image: UIImage(systemName: "map"), tag: 0)
        tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        viewController.tabBarItem = tabBarItem
        viewController.navigationItem.title = "Current".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setupBarAppearence() {
        let designSystem: DesignSystem = DefaultDesignSystem.shared
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        
        UINavigationBar.appearance().barTintColor = designSystem.palette.backgroundPrimary
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        
        self.navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.largeTitle]
    }
}
