//
//  ExplorerCoordinator.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

class ExploreCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        let vc = ExploreViewController()
        vc.coordinator = self
        let tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "globe.americas"), tag: 0)
        tabBarItem.selectedImage = UIImage(systemName: "globe.americas.fill")
        vc.tabBarItem = tabBarItem
        vc.navigationItem.title = "Explore"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func createNewRoadmap() {
        let coordinator = NewRoadmapCoordinator(navigationController: UINavigationController())
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
        
        navigationController.present(coordinator.navigationController, animated: true) {
            print("OI")
        }
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

extension ExploreCoordinator: PresentationCoordinatorDelegate {
    func didFinishPresent(of coordinator: Coordinator) {
        print(childCoordinators)
        childCoordinators = childCoordinators.filter { $0 === coordinator }
        print(childCoordinators)
    }
}


protocol PresentationCoordinatorDelegate: AnyObject {
    func didFinishPresent(of coordinator: Coordinator)
}
