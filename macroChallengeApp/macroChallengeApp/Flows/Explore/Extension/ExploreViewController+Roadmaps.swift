//
//  ExploreViewController+Roadmaps.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 26/09/22.
//

import Foundation
import UIKit
import GoogleMobileAds

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
            FirebaseManager.shared.createAnalyticsEvent(event: "selected_roadmap", parameters: ["roadmap_name": roadmaps[indexPath.row].name])
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
            if roadmap.id == -5 {
                guard let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: UIAdViewCell.identifier, for: indexPath) as? UIAdViewCell else {
                    preconditionFailure("Cell not find")
                }
                guard let nAd = adsNatives[0] as? GADNativeAd else {preconditionFailure("Cell not find")}
                nAd.delegate = self
                nAd.rootViewController = self
                
                // Prepare ad content
                let nativeAd = nAd
                cell1.adView.nativeAd = nativeAd
                
                // Add content to native view
                cell1.headline.text = nativeAd.headline
                cell1.adView.mediaView?.mediaContent = nativeAd.mediaContent

                cell1.body.text = nativeAd.body
                cell1.adView.bodyView?.isHidden = nativeAd.body == nil

                cell1.icon.image = nativeAd.icon?.image
                cell1.adView.iconView?.isHidden = nativeAd.icon == nil

                cell1.advertiser.text = nativeAd.advertiser
                cell1.adView.advertiserView?.isHidden = nativeAd.advertiser == nil

                cell1.adView.callToActionView?.isUserInteractionEnabled = false
                
                return  cell1
            } else {
                FirebaseManager.shared.getImage(category: 0, uuid: roadmap.imageId) { image in
                    cell.cover.image = image
                }
                cell.setupRoadmapBackEnd(roadmap: roadmap)
            }
            
            
        } else if !roadmapsMock.isEmpty {
            let roadmap = roadmapsMock[indexPath.row]
            cell.setupRoadmapMock(roadmap: roadmap)
        }
        return cell
    }
}
