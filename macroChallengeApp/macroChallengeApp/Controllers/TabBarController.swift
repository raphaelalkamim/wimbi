//
//  TabBarController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

class TabBarController: UITabBarController {
    private let designSystem: DesignSystem = DefaultDesignSystem.shared
    private let explore = ExploreCoordinator(navigationController: UINavigationController())
    private let current = CurrentCoordinator(navigationController: UINavigationController())
    private let profile = ProfileCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        explore.start()
        current.start()
        profile.start()
        
        viewControllers = [explore.navigationController, current.navigationController, profile.navigationController]
        tabBar.barTintColor = designSystem.palette.backgroundPrimary
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            appearance.backgroundColor = designSystem.palette.backgroundPrimary
        }
    }
}
