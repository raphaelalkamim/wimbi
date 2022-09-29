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
    weak var delegate: PresentationCoordinatorDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        let viewController = ProfileViewController()
        viewController.coordinator = self
        
        let tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewController.tabBarItem = tabBarItem
        viewController.navigationItem.title = "Profile"
        navigationController.pushViewController(viewController, animated: true)
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
    func openRoadmap(roadmap: RoadmapLocal) {
        let viewController = MyTripViewController()
        viewController.coordinator = self
        viewController.roadmap = roadmap
        viewController.navigationItem.title = roadmap.name
        navigationController.pushViewController(viewController, animated: true)
    }
    func startViewRoadmap() {
        let viewController = MyTripViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Egito"
        navigationController.pushViewController(viewController, animated: true)
    }
    func startActivity(day: DayLocal) {
        let viewController = NewActivityViewController()
        viewController.coordinator = self
        viewController.day = day
        viewController.navigationItem.title = "New Activity"
        //navigationController.present(viewController, animated: true)
        navigationController.pushViewController(viewController, animated: true)
    }

    func openLocationActivity(delegate: ChangeTextTableDelegate) {
        let viewController = LocationNewActivityViewController()
        viewController.delegate = delegate
        viewController.coordinator = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func settings() {
        let viewController = SettingsViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Settings"
        navigationController.pushViewController(viewController, animated: true)
    }
    func backPage() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: false)
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
    func didFinishPresent(of coordinator: Coordinator, isNewRoadmap isnewRoadmap: Bool) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
}
