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
        viewController.navigationItem.title = "Category".localized()
        navigationController.navigationBar.prefersLargeTitles = true
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
    func dismiss(isNewRoadmap: Bool) {
        navigationController.dismiss(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: isNewRoadmap)
    }
    
    func dismissRoadmap(isNewRoadmap: Bool) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let string = NSAttributedString(string: "Are you sure?".localized(), attributes: titleAtt)
        alert.setValue(string, forKey: "attributedTitle")
        
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let subtitleString = NSAttributedString(string: "By canceling you will lose all your progress".localized(), attributes: subtitleAtt)
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Back".localized(), style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
            self.navigationController.dismiss(animated: true)
            self.delegate?.didFinishPresent(of: self, isNewRoadmap: isNewRoadmap)
        }))
        self.navigationController.present(alert, animated: true)
    }
    
    func back() {
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
