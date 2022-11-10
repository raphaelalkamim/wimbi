//
//  TabBarController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit
import AVFoundation
import AVKit
import AVFAudio

class TabBarController: UITabBarController {
    private let designSystem: DesignSystem = DefaultDesignSystem.shared
    private let explore = ExploreCoordinator(navigationController: UINavigationController())
    private let current = CurrentCoordinator(navigationController: UINavigationController())
    private let profile = ProfileCoordinator(navigationController: UINavigationController())
    
    var roadmaps = RoadmapRepository.shared.getRoadmap()
    var roadmap: RoadmapLocal = RoadmapLocal()
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "stopVideo"), object: player.currentTime)
    }
    
    override func viewDidLoad() {
        self.loadScene()
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            appearance.backgroundColor = self.designSystem.palette.backgroundPrimary
        }
    }
    
    func setupCoordnators() {
        explore.start()
        if !roadmaps.isEmpty {
            roadmaps.sort {
                $0.date ?? Date() < $1.date ?? Date()
            }
            roadmap = roadmaps[0]
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "dd/MM/yy"
            
            if configCountDown() > 0 {
                // abre o countdown
                current.start()
            } else if configCountDown() == 0 && dateFormatter.string(from: date) != dateFormatter.string(from: roadmap.date ?? Date()) {
                current.start()

            } else {
                current.startCurrent(roadmap: roadmap)
            }
        } else {
            // abre o countdown mas vai pra empty view
            current.start()
        }
        profile.start()
        profile.delegate = self
        
    }
    func setupNavigators() {
        viewControllers = [explore.navigationController, current.navigationController, profile.navigationController]
    }
    func configCountDown() -> Int {
        let time = Int((roadmap.date?.timeIntervalSince(Date()) ?? 300) / (60 * 60 * 24))
        return time
    }
    func loadScene() {
        self.loadVideo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.stopVideo()
            self.setupCoordnators()
            self.setupNavigators()
            self.tabBar.barTintColor = self.designSystem.palette.backgroundPrimary
        }
    }
    func loadVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "giphy", ofType: "mp4")
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = 1
        
        self.view.layer.addSublayer(playerLayer)
        player.seek(to: CMTime.zero)
        player.play()
    }
    func stopVideo() {
        player.pause()
        playerLayer.removeFromSuperlayer()
    }
}

extension TabBarController: PresentationCoordinatorDelegate {
    func didFinishPresent(of coordinator: Coordinator, isNewRoadmap: Bool) {
        if isNewRoadmap == true {
            coordinator.childCoordinators = coordinator.childCoordinators.filter { $0 === coordinator }
            coordinator.navigationController.tabBarController?.selectedIndex = 0
        }
    }
}
