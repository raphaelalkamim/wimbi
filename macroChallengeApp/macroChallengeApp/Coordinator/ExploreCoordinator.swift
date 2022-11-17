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
    weak var delegate: PresentationCoordinatorDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        let viewController = ExploreViewController()
        viewController.coordinator = self
        let tabBarItem = UITabBarItem(title: "Explore".localized(), image: UIImage(systemName: "globe.americas"), tag: 0)
        tabBarItem.selectedImage = UIImage(systemName: "globe.americas.fill")
        viewController.tabBarItem = tabBarItem
        viewController.navigationItem.title = "Explore".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func createNewRoadmap() {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            let coordinator = NewRoadmapCoordinator(navigationController: UINavigationController())
            childCoordinators.append(coordinator)
            coordinator.delegate = self
            coordinator.start()
            navigationController.present(coordinator.navigationController, animated: true)
        } else {
            startLogin()
        }
    }
    
    func startLogin() {
        let viewController = LoginViewController()
        viewController.coordinatorExplore = self
        viewController.navigationItem.title = "Login"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startProfile() {
        let viewController = ProfileViewController()
        viewController.exploreCoordinator = self
        viewController.navigationItem.title = "Profile".localized()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backItem?.setHidesBackButton(true, animated: false)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func previewRoadmap(roadmapId: Int) {
        let viewController = PreviewRoadmapViewController()
        viewController.coordinator = self
        viewController.roadmapId = roadmapId
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func previewMockRoadmap(roadmap: Roadmaps) {
        let viewController = PreviewRoadmapViewController()
        viewController.coordinator = self
        viewController.roadmap = roadmap
        viewController.setupContent(roadmap: roadmap)
        viewController.previewView.hiddenSpinner()
        navigationController.pushViewController(viewController, animated: true)
    }
    func back() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: false)
    }
    
    func showActivitySheet(tripVC: PreviewRoadmapViewController, activity: Activity) {
        let viewControllerToPresent = DetailViewController()
        viewControllerToPresent.detailView.setupContentByBackend(activity: activity)
        viewControllerToPresent.delegateExplore = tripVC
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true

        }
        navigationController.present(viewControllerToPresent, animated: true, completion: nil)
        
    }
    
    func startOnboarding() {
        let viewController = OnboardingViewController()
        viewController.coordinatorExplore = self
        navigationController.present(viewController, animated: true)
        navigationController.modalPresentationStyle = .formSheet
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
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
    func didFinishPresent(of coordinator: Coordinator, isNewRoadmap: Bool) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
        if isNewRoadmap == true {
            navigationController.tabBarController!.selectedIndex = 2
        }
    }
}

protocol PresentationCoordinatorDelegate: AnyObject {
    func didFinishPresent(of coordinator: Coordinator, isNewRoadmap: Bool)
}
