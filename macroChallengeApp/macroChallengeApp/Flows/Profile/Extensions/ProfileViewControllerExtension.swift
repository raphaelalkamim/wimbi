//
//  ExtensionProfileViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 15/09/22.
//

import Foundation
import UIKit

extension ProfileViewController {
    func setupProfileView() {
        view.addSubview(profileView)
        setupConstraints()
    }
    func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate {
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roadmaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        coordinator?.openRoadmap(roadmap: roadmaps[indexPath.row] )
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        let isNew = false
        cell.setup(name: roadmaps[indexPath.row].name ?? "Erro", image: roadmaps[indexPath.row].imageId ?? "mountain0", isNew: isNew)
        cell.setupImage(category: roadmaps[indexPath.row].category ?? "noCategory")
        cell.backgroundColor = designSystem.palette.backgroundCell
        cell.layer.cornerRadius = 16
        
        cell.title.translatesAutoresizingMaskIntoConstraints = false
        
        if cell.title.text!.count < 15 {
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.xLargePositive).isActive = true
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.smallPositive).isActive = false
        } else {
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.xLargePositive).isActive = false
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.smallPositive).isActive = true

        }
        
        if let user = user {
            cell.title.text = user.userRoadmap[indexPath.row].roadmap.name
            cell.roadmapImage.image = UIImage(named: user.userRoadmap[indexPath.row].roadmap.imageId)
        }
        return cell
    }
}
