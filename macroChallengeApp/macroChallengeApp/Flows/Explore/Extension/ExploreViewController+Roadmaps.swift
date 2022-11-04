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
        explorerView.setupSearchController(locationTable: locationSearchTable)
        explorerView.bindCollectionView(delegate: self, dataSource: self)
        explorerView.addSearchBarNavigation(navigation: navigationItem)
        explorerView.searchBar.delegate = self
        definesPresentationContext = true
        setupConstraints()
    }
    func setupConstraints() {
        explorerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func emptyState(conection: Bool) {
        if conection {
            self.explorerView.roadmapsCollectionView.isHidden = false
            self.explorerView.emptyStateTitle.isHidden = true
            self.explorerView.emptyStateImage.isHidden = true
            self.explorerView.roadmapsCollectionView.isScrollEnabled = true
            if !self.roadmaps.isEmpty {
                self.explorerView.hiddenSpinner()
            }
        } else {
            self.explorerView.hiddenSpinner()
            self.explorerView.roadmapsCollectionView.isHidden = true
            self.explorerView.emptyStateTitle.isHidden = false
            self.explorerView.emptyStateImage.isHidden = false
            self.explorerView.roadmapsCollectionView.isScrollEnabled = false
        }
        // self.network.stopMonitoring()
    }
}

extension ExploreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.previewRoadmap(roadmapId: roadmapsMock[indexPath.row].id)
    }
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
            cell.costByPerson.text = "\(roadmap.currency) \(roadmap.budget / 1000) \(amount)"
            cell.categoryName.text = roadmap.category.localized()
            cell.setupColor(category: roadmap.category)
            cell.totalLikes.text = "\(roadmap.likesCount)"
        }
        
        return cell
    }
}
