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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        let vc = MyTripViewController()
        vc.navigationItem.title = "Egito"
        navigationController?.pushViewController(vc, animated: true)
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        cell.setup()
        cell.backgroundColor = designSystem.palette.backgroundCell
        cell.layer.cornerRadius = 16
        
        if indexPath.row == 1 || indexPath.row == 5 {
            cell.title.text = "Fernando de Noronha"
        }
        
        cell.title.translatesAutoresizingMaskIntoConstraints = false
        
        if cell.title.text!.count <= 15 {
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.largePositive).isActive = true
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.smallPositive).isActive = false

        } else {
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.smallPositive).isActive = true
            cell.title.topAnchor.constraint(equalTo: cell.roadmapImage.bottomAnchor, constant: designSystem.spacing.largePositive).isActive = false

        }
        
        return cell

    }
    
}
