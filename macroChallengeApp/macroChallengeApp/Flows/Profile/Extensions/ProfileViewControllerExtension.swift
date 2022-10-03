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
    // MARK: Long press
    @objc public func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: profileView.myRoadmapCollectionView)
            if let indexPath = profileView.myRoadmapCollectionView.indexPathForItem(at: touchPoint) {
                if roadmaps.isEmpty {
                    let action = UIAlertController(title: "Não é possível deletar", message: nil, preferredStyle: .actionSheet)
                    action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                        self?.profileView.myRoadmapCollectionView.reloadData()
                    }))
                    present(action, animated: true)
                } else {
                    let action = UIAlertController(title: "Deletar todo o conteúdo de '\(roadmaps[indexPath.item].name ?? "NONE")'", message: "O conteúdo não poderá ser recuperado.", preferredStyle: .actionSheet)
                    
                    action.addAction(UIAlertAction(title: "Deletar", style: .destructive, handler: { [weak self] _ in
                            do {
                                try RoadmapRepository.shared.deleteRoadmap(roadmap: self!.roadmaps[indexPath.row])
                            } catch {
                                print(error)
                            }
                        
                        self?.profileView.myRoadmapCollectionView.reloadData()
                    }))
                    action.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    present(action, animated: true)
                    
                }
                navigationController?.navigationBar.prefersLargeTitles = true
            }
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
