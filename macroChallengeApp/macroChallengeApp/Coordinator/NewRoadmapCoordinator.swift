//
//  NewRoadmapCoordinator.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 14/09/22.
//

import UIKit

class NewRoadmapCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    weak var delegate: PresentationCoordinatorDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        navigationController.modalPresentationStyle = .fullScreen
        let viewController = CategoryViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Category"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startDestiny(roadmap: Roadmaps) {
        let viewController = DestinyViewController(roadmap: roadmap)
        viewController.coordinator = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startDays(roadmap: Roadmaps) {
        let viewController = DaysViewController(roadmap: roadmap)
        viewController.coordinator = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    func startReview(roadmap: Roadmaps) {
        let viewController = ReviewTravelViewController(roadmap: roadmap)
        viewController.coordinator = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    func dismiss() {
        navigationController.dismiss(animated: true)
        delegate?.didFinishPresent(of: self)
    }
    func back() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self)
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
