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
    weak var delegate: PresentationCoordinatorDelegate?
    
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
        viewController.navigationItem.title = "Current Itinerary".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startCurrent(roadmap: Roadmap) {
        let viewController = MyTripViewController()
        viewController.coordinatorCurrent = self
        viewController.roadmap = roadmap
        
        let tabBarItem = UITabBarItem(title: "Current".localized(), image: UIImage(systemName: "map"), tag: 0)
        tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        viewController.tabBarItem = tabBarItem
        viewController.navigationItem.title = viewController.roadmap.name
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setupBarAppearence() {
        let designSystem: DesignSystem = DefaultDesignSystem.shared
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        
        UINavigationBar.appearance().barTintColor = designSystem.palette.backgroundPrimary
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        
        self.navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont.largeTitle)]
    }
    // MARK: Current Roadmap MyTripViewController
    func editRoadmap(editRoadmap: Roadmap, delegate: MyTripViewController) {
        let coordinator = NewRoadmapCoordinator(navigationController: UINavigationController())
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.startEditing(editRoadmap: editRoadmap, delegate: delegate)
        navigationController.present(coordinator.navigationController, animated: true) {
        }
    }
    
    func startActivity(roadmap: Roadmap, day: Day, delegate: MyTripViewController) {
        let viewController = NewActivityViewController()
        viewController.delegate = delegate
        viewController.coordinatorCurrent = self
        viewController.day = day
        viewController.roadmap = roadmap
        viewController.navigationItem.title = "New activity".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func editActivity(roadmap: Roadmap, day: Day, delegate: MyTripViewController, activity: Activity) {
        let viewController = NewActivityViewController()
        viewController.delegate = delegate
        viewController.coordinatorCurrent = self
        viewController.day = day
        viewController.edit = true
        viewController.activityEdit = activity
        viewController.roadmap = roadmap
        viewController.navigationItem.title = "New activity".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openLocationActivity(delegate: ChangeTextTableDelegate, roadmap: Roadmap) {
        let viewController = LocationNewActivityViewController()
        viewController.coordsMap = roadmap.location
        viewController.delegate = delegate
        viewController.coordinatorCurrent = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func backPage() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: false)
    }
    
    func showActivitySheet(tripVC: MyTripViewController, roadmap: Roadmap, day: Day, activity: Activity) {
        let viewControllerToPresent = DetailViewController()
        viewControllerToPresent.detailView.setupContent(activity: activity)
        viewControllerToPresent.activity = activity
        viewControllerToPresent.roadmap = roadmap
        viewControllerToPresent.day = day
        viewControllerToPresent.delegate = tripVC
        
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
}

extension CurrentCoordinator: PresentationCoordinatorDelegate {
    func didFinishPresent(of coordinator: Coordinator, isNewRoadmap isnewRoadmap: Bool) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
}
