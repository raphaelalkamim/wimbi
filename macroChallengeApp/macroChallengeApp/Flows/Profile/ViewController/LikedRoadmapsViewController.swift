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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setuplikedRoadmapsView()
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
