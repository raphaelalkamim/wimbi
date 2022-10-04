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
    
    var roadmaps = RoadmapRepository.shared.getRoadmap()
    var roadmap: RoadmapLocal = RoadmapLocal()
    
    override func viewDidLoad() {
        roadmaps.sort {
            $0.date ?? Date() < $1.date ?? Date()
        }
        roadmap = roadmaps[0]
        self.setup()
        viewControllers = [explore.navigationController, current.navigationController, profile.navigationController]
        tabBar.barTintColor = designSystem.palette.backgroundPrimary
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            appearance.backgroundColor = designSystem.palette.backgroundPrimary
        }
    }
    
    func setup() {
        explore.start()
        if !roadmaps.isEmpty {
            let time = configCountDown()
            if time <= 0 {
                current.startCurrent(roadmap: roadmap)
            } else {
                current.start()
            }
        }
        profile.start()

    }
    func configCountDown() -> Int {
        var time = Int((roadmap.date?.timeIntervalSince(Date()) ?? 300) / (60 * 60 * 24))
        if time <= 0 {
            time = 0
        }
        return time
    }
}
