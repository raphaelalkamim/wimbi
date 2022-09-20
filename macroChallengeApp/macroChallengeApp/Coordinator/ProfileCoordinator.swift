//
//  ProfileCoordinator.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        let vc = ProfileViewController()
        vc.coordinator = self
        
        let tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        vc.tabBarItem = tabBarItem
        vc.navigationItem.title = "Profile"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func newRoadmap() {
        let coordinator = NewRoadmapCoordinator(navigationController: UINavigationController())
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
        
        navigationController.present(coordinator.navigationController, animated: true) {
            print("OI")
        }
    }
    
    func settings() {
        let vc = SettingsViewController()
        vc.coordinator = self
        vc.navigationItem.title = "Settings"
        navigationController.pushViewController(vc, animated: true)
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

extension ProfileCoordinator: PresentationCoordinatorDelegate {
    func didFinishPresent(of coordinator: Coordinator) {
        print(childCoordinators)
        childCoordinators = childCoordinators.filter { $0 === coordinator }
        print(childCoordinators)
    }
}
