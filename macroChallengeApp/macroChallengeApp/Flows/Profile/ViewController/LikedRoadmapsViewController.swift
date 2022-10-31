//
//  LikedRoadmapsViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit

class LikedRoadmapsViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let likedRoadmapsView = LikedRoadmapsView()
    var likedRoadmaps: [RoadmapDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setuplikedRoadmapsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getLikedRoadmaps()
    }
    
    func getLikedRoadmaps() {
        DataManager.shared.getLikedRoadmaps { roadmaps in
            print(roadmaps)
            self.likedRoadmaps = roadmaps
            self.likedRoadmapsView.likedRoadmapsCollectionView.reloadData()
        }
    }
}

extension LikedRoadmapsViewController {
    func setuplikedRoadmapsView() {
        view.addSubview(likedRoadmapsView)
        setupConstraints()
    }
    func setupConstraints() {
        likedRoadmapsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
