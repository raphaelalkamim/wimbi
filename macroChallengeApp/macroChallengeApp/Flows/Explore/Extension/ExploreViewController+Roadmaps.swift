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
            cell.subtitle.text = "\(roadmap.peopleCount) viajante  •  \(roadmap.dayCount) dias"
            cell.costByPerson.text = "R$ \(roadmap.budget / 1000) mil por pessoa"
            cell.categoryName.text = roadmap.category
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.previewRoadmap(roadmapId: roadmaps[indexPath.row].id)
    }
    
}
