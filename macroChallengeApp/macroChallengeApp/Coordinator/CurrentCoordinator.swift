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
        viewController.navigationItem.title = "Current Roadmap".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startCurrent(roadmap: RoadmapLocal) {
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
        
        self.navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.largeTitle]
    }
    // MARK: Current Roadmap MyTripViewController
    func editRoadmap(editRoadmap: RoadmapLocal, delegate: MyTripViewController) {
        let coordinator = NewRoadmapCoordinator(navigationController: UINavigationController())
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        coordinator.startEditing(editRoadmap: editRoadmap, delegate: delegate)
        navigationController.present(coordinator.navigationController, animated: true) {
        }
    }
    
    func startActivity(roadmap: RoadmapLocal, day: DayLocal, delegate: MyTripViewController) {
        let viewController = NewActivityViewController()
        viewController.delegate = delegate
        viewController.coordinatorCurrent = self
        viewController.day = day
        viewController.roadmap = roadmap
        viewController.navigationItem.title = "New activity".localized()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func editActivity(roadmap: RoadmapLocal, day: DayLocal, delegate: MyTripViewController, activity: ActivityLocal) {
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
    
    func openLocationActivity(delegate: ChangeTextTableDelegate, roadmap: RoadmapLocal) {
        let viewController = LocationNewActivityViewController()
        if let location = roadmap.location {
            viewController.coordsMap = location
        }
        viewController.delegate = delegate
        viewController.coordinatorCurrent = self
        UIAccessibility.post(notification: .screenChanged, argument: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func backPage() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: false)
    }
    
    func showActivitySheet(tripVC: MyTripViewController, activity: ActivityLocal) {
        var value = ""
        var currency = ""
        let starts = "Starts at: ".localized()
        let coin = "Value: ".localized()
        let type = "Type: ".localized()
        let viewControllerToPresent = DetailViewController()
        viewControllerToPresent.detailView.activityTitle.text = activity.name
        viewControllerToPresent.detailView.activityIcon.image = UIImage(named: "\(activity.category ?? "food")Selected")
        viewControllerToPresent.detailView.activityCategory.text = type + (activity.category?.capitalized.localized() ?? "Category")
        if activity.budget == 0.0 {
            value = "Free"
            currency = ""
        } else {
            value = "\(activity.budget)"
            currency = "\(activity.currencyType ?? "R$")"
        }
        
        viewControllerToPresent.detailView.activityInfo.text = "\(starts)\(activity.hour ?? "8h")    •    \(coin)\(currency )\(value)"
        viewControllerToPresent.detailView.local.text = activity.location
        viewControllerToPresent.detailView.details.text = activity.tips
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 17)]
        viewControllerToPresent.detailView.linkButton.setAttributedTitle(NSAttributedString(string: "\(activity.link ?? "https://www.google.com")", attributes: attributes), for: .normal)
        viewControllerToPresent.delegate = tripVC
        
        if activity.location?.isEmpty == true {
            viewControllerToPresent.detailView.local.text = "Endereço não disponibilizado"
            viewControllerToPresent.detailView.local.textColor = .caption

        }
        if activity.category == "empty" {
            viewControllerToPresent.detailView.activityIcon.image = UIImage(named: "empty")
            viewControllerToPresent.detailView.activityCategory.text = "No type"
        }
        if activity.link?.isEmpty == true {
            viewControllerToPresent.detailView.linkButton.setAttributedTitle(NSAttributedString(string: "Contato indisponível ", attributes: attributes), for: .normal)
            viewControllerToPresent.detailView.linkButton.isEnabled = false
            viewControllerToPresent.detailView.linkButton.setTitleColor(.caption, for: .normal)
        }
        
        if activity.tips?.isEmpty == true {
            viewControllerToPresent.detailView.details.text = "Nenhum detalhe informado"
            viewControllerToPresent.detailView.details.textColor = .caption
        }
        
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
