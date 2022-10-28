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
//        viewController.navigationItem.title = "Trip"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
        delegate?.didFinishPresent(of: self, isNewRoadmap: false)
    }
    
    func showActivitySheet(tripVC: PreviewRoadmapViewController, activity: Activity) {
        var value = ""
        var currency = ""
        let starts = "Starts at: ".localized()
        let coin = "Value: ".localized()
        let type = "Type: ".localized()
        let viewControllerToPresent = DetailViewController()
        viewControllerToPresent.detailView.activityTitle.text = activity.name
        viewControllerToPresent.detailView.activityIcon.image = UIImage(named: "\(activity.category )Selected")
        viewControllerToPresent.detailView.activityCategory.text = type + (activity.category.capitalized.localized())
        if activity.budget == 0.0 {
            value = "Free"
            currency = ""
        } else {
            value = "\(activity.budget)"
            currency = "\(activity.currency)"
        }
        viewControllerToPresent.detailView.activityInfo.text = "\(starts)\(activity.hour)    •    \(coin)\(currency )\(value)"
        viewControllerToPresent.detailView.local.text = activity.location
        viewControllerToPresent.detailView.details.text = activity.tips
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 15)]
        viewControllerToPresent.detailView.linkButton.setAttributedTitle(NSAttributedString(string: "\(activity.link)", attributes: attributes), for: .normal)
        viewControllerToPresent.delegateExplore = tripVC
        
        if activity.location.isEmpty == true {
            viewControllerToPresent.detailView.local.text = "Endereço não disponibilizado"
            viewControllerToPresent.detailView.local.textColor = .caption

        }
        if activity.category == "empty" {
            viewControllerToPresent.detailView.activityIcon.image = UIImage(named: "empty")
            viewControllerToPresent.detailView.activityCategory.text = "No type"
        }
        if activity.link.isEmpty == true {
            viewControllerToPresent.detailView.linkButton.setAttributedTitle(NSAttributedString(string: "Contato indisponível ", attributes: attributes), for: .normal)
            viewControllerToPresent.detailView.linkButton.isEnabled = false
            viewControllerToPresent.detailView.linkButton.setTitleColor(.caption, for: .normal)
        }
        
        if activity.tips.isEmpty == true {
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
