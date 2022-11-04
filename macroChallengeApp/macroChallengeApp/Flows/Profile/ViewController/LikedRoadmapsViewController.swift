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
    weak var exploreCoordinator: ExploreCoordinator?
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
            self.likedRoadmapsView.bindCollectionView(delegate: self, dataSource: self)
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

extension LikedRoadmapsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        exploreCoordinator?.previewRoadmap(roadmapId: likedRoadmaps[indexPath.row].id)
    }
}

extension LikedRoadmapsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedRoadmaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoadmapExploreCollectionViewCell.identifier, for: indexPath) as? RoadmapExploreCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        
        if !likedRoadmaps.isEmpty {
            let roadmap = likedRoadmaps[indexPath.row]
            cell.cover.image = UIImage(named: roadmap.imageId)
            cell.title.text = roadmap.name
            let travelers = "travelers  •".localized()
            let days = "days".localized()
            cell.subtitle.text = "\(roadmap.peopleCount) \(travelers)  \(roadmap.dayCount) \(days)"
            let amount = "thousand per person".localized()
            cell.costByPerson.text = "\(roadmap.currency) \(roadmap.budget / 1000) \(amount)"
            cell.categoryName.text = roadmap.category.localized()
            cell.setupColor(category: roadmap.category)
            cell.totalLikes.text = "\(roadmap.likesCount)"
        }
        
        return cell
    }
}
