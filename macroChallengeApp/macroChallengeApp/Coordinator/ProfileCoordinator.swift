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
        
        let tabBarItem = UITabBarItem(title: "Profile".localized(), image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewController.tabBarItem = tabBarItem
        viewController.navigationItem.title = "Profile".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func newRoadmap() {
        let coordinator = NewRoadmapCoordinator(navigationController: UINavigationController())
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.start()
        navigationController.present(coordinator.navigationController, animated: true) {
        }
    }
    
    func startLogin() {
        let viewController = LoginViewController()
        viewController.coordinatorProfile = self
        viewController.navigationItem.title = "Login"
        let tabBarItem = UITabBarItem(title: "Profile".localized(), image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewController.tabBarItem = tabBarItem
        viewController.navigationItem.title = "Profile".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openRoadmap(roadmap: RoadmapLocal) {
        let viewController = MyTripViewController()
        viewController.coordinator = self
        viewController.roadmap = roadmap
        viewController.navigationItem.title = roadmap.name
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func editRoadmap(editRoadmap: RoadmapLocal, delegate: MyTripViewController) {
        let coordinator = NewRoadmapCoordinator(navigationController: UINavigationController())
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.startEditing(editRoadmap: editRoadmap, delegate: delegate)
        navigationController.present(coordinator.navigationController, animated: true)
    }
    
    func startActivity(roadmap: RoadmapLocal, day: DayLocal, delegate: MyTripViewController) {
        let viewController = NewActivityViewController()
        viewController.delegate = delegate
        viewController.coordinator = self
        viewController.day = day
        viewController.roadmap = roadmap
        viewController.navigationItem.title = "New activity".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    func editActivity(roadmap: RoadmapLocal, day: DayLocal, delegate: MyTripViewController, activity: ActivityLocal) {
        let viewController = NewActivityViewController()
        viewController.delegate = delegate
        viewController.coordinator = self
        viewController.day = day
        viewController.edit = true
        viewController.activityEdit = activity
        viewController.roadmap = roadmap
        viewController.navigationItem.title = "New activity".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    func openLocationActivity(delegate: ChangeTextTableDelegate, roadmap: RoadmapLocal) {
        let viewController = LocationNewActivityViewController()
        if let location = roadmap.location {
            viewController.coordsMap = location
        }
        viewController.delegate = delegate
        viewController.coordinator = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func settings(profileVC: ProfileViewController) {
        let viewController = SettingsViewController()
        viewController.coordinator = self
        viewController.delegate = profileVC
        viewController.navigationItem.title = "Settings".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showActivitySheet(tripVC: MyTripViewController, activity: ActivityLocal) {
        let viewControllerToPresent = DetailViewController()
        viewControllerToPresent.detailView.setupContent(activity: activity)
        viewControllerToPresent.activity = activity
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
    
    func showAlertController(alert: UIAlertController) {
        navigationController.present(alert, animated: true)
    }
    
    func startEditProfile() {
        let viewController = EditProfileViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Edit profile".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    func startLikedRoadmaps() {
        let viewController = LikedRoadmapsViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Liked itineraries".localized()
        navigationController.pushViewController(viewController, animated: true)
    }

    func startNotifications() {
        let viewController = NotificationsViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Notifications".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startTerms() {
        let viewController = TermsViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Privacy Policies".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func backPage() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: false)
    }
    
    func startOnboarding() {
        let viewController = OnboardingViewController()
        viewController.coordinator = self
//        viewController.navigationItem.title = "Edit profile".localized()
        navigationController.present(viewController, animated: true)
        navigationController.modalPresentationStyle = .formSheet
    }
    
    func startExplore() {
        delegate?.didFinishPresent(of: self, isNewRoadmap: true)
        navigationController.dismiss(animated: true)
        UserDefaults.standard.set(true, forKey: "onboard")
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

extension ProfileCoordinator: PresentationCoordinatorDelegate {
    func didFinishPresent(of coordinator: Coordinator, isNewRoadmap isnewRoadmap: Bool) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
}
