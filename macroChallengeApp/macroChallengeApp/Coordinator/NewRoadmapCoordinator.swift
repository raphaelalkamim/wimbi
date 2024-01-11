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

    func startDestiny(roadmap: Roadmap) {
        let viewController = DestinyViewController(roadmap: roadmap)
        viewController.coordinator = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startDays(roadmap: Roadmap) {
        let viewController = DaysViewController(roadmap: roadmap)
        viewController.coordinator = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    func startReview(roadmap: Roadmap) {
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
        let titleFont = UIFont(name: "Avenir-Black", size: 18)!
        let titleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .headline).scaledFont(for: titleFont)]
        let string = NSAttributedString(string: "Are you sure?".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(string, forKey: "attributedTitle")
        
        let subtitleFont = UIFont(name: "Avenir-Roman", size: 14)!
        let subtitleAtt = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .footnote).scaledFont(for: subtitleFont)]
        let subtitleString = NSAttributedString(string: "By canceling you’ll lose your entire progress.".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        alert.setValue(subtitleString, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "No".localized(), style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
            self.navigationController.dismiss(animated: true)
            self.delegate?.didFinishPresent(of: self, isNewRoadmap: isNewRoadmap)
        }))

        navigationController.present(alert, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: false)
    }
    
    // MARK: Edit Functions
    func startEditing(editRoadmap: Roadmap, delegate: MyTripViewController) {
        navigationController.modalPresentationStyle = .fullScreen
        let viewController = CategoryViewController()
        viewController.coordinator = self
        viewController.navigationItem.title = "Category".localized()
        viewController.edit = true
        viewController.editRoadmap = editRoadmap
        viewController.delegateRoadmap = delegate
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startEditDestiny(roadmap: Roadmap, editRoadmap: Roadmap, delegate: MyTripViewController) {
        let viewController = DestinyViewController(roadmap: roadmap)
        viewController.coordinator = self
        viewController.editRoadmap = editRoadmap
        viewController.edit = true
        viewController.delegateRoadmap = delegate
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    func startEditDays(roadmap: Roadmap, editRoadmap: Roadmap, delegate: MyTripViewController) {
        let viewController = DaysViewController(roadmap: roadmap)
        viewController.coordinator = self
        viewController.editRoadmap = editRoadmap
        viewController.edit = true
        viewController.delegateRoadmap = delegate
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    func startEditReview(roadmap: Roadmap, editRoadmap: Roadmap, delegate: MyTripViewController) {
        let viewController = ReviewTravelViewController(roadmap: roadmap)
        viewController.coordinator = self
        viewController.editRoadmap = editRoadmap
        viewController.edit = true
        viewController.delegateRoadmap = delegate
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
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
}
