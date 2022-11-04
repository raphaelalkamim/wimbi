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
        if roadmapsMock.isEmpty {
            coordinator?.previewRoadmap(roadmapId: roadmaps[indexPath.row].id)
        } else {
            coordinator?.previewMockRoadmap(roadmap: roadmapsMock[indexPath.row])
        }
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if roadmaps.isEmpty { return roadmapsMock.count }
        return roadmaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoadmapExploreCollectionViewCell.identifier, for: indexPath) as? RoadmapExploreCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        
        if !roadmaps.isEmpty {
            let roadmap = roadmaps[indexPath.row]
            cell.setupRoadmapBackEnd(roadmap: roadmap)
           
        } else if !roadmapsMock.isEmpty {
            let roadmap = roadmapsMock[indexPath.row]
            cell.setupRoadmapMock(roadmap: roadmap)
        }
        return cell
    }
}
