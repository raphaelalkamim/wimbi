//
//  ExploreViewController+Roadmaps.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 26/09/22.
//

import Foundation
import UIKit

extension ExploreViewController {
    func setupExplorerView() {
        view.addSubview(explorerView)
        setupConstraints()
    }
    func setupConstraints() {
        explorerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ExploreViewController: UICollectionViewDelegate {
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roadmaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoadmapExploreCollectionViewCell.identifier, for: indexPath) as? RoadmapExploreCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        
        if !roadmaps.isEmpty {
            let roadmap = roadmaps[indexPath.row]
            cell.cover.image = UIImage(named: roadmap.imageId)
            cell.title.text = roadmap.name
            let travelers = "travelers  •".localized()
            let days = "days".localized()
            cell.subtitle.text = "\(roadmap.peopleCount) \(travelers)  \(roadmap.dayCount) \(days)"
            let amount = "thousand per person".localized()
            cell.costByPerson.text = "R$ \(roadmap.budget / 1000) \(amount)"
            cell.categoryName.text = roadmap.category
            cell.setupColor(category: roadmap.category)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.previewRoadmap(roadmapId: roadmaps[indexPath.row].id)
    }
    
}
