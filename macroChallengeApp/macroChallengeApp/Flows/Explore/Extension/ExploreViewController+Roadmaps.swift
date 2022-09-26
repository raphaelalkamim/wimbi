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
            return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoadmapExploreCollectionViewCell.identifier, for: indexPath) as? RoadmapExploreCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            return cell
    }
}
