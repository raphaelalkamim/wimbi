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
    // MARK: Long press and delete
    @objc public func handleLongPress(sender: UILongPressGestureRecognizer) {
        network.startMonitoring()
        if sender.state == .began {
            let touchPoint = sender.location(in: profileView.myRoadmapCollectionView)
            if let indexPath = profileView.myRoadmapCollectionView.indexPathForItem(at: touchPoint) {
                if roadmaps.isEmpty || !network.isReachable {
                    let action = UIAlertController(title: "Can't delete", message: nil, preferredStyle: .actionSheet)
                    action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                        self?.profileView.myRoadmapCollectionView.reloadData()
                    }))
                    present(action, animated: true)
                } else {
                    let action = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                    
                    let roadmapName = "'\(roadmaps[indexPath.item].name ?? "NONE")'"
                    
                    let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 16)]
                    let title = "Delete all content from".localized()
                    let string = NSAttributedString(string: "\(title) \(roadmapName)", attributes: titleAtt as [NSAttributedString.Key: Any])
                    action.setValue(string, forKey: "attributedTitle")
                    
                    let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 16)]
                    let subtitleString = NSAttributedString(string: "The content cannot be recovered.".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
                    action.setValue(subtitleString, forKey: "attributedMessage")
                    
                    action.addAction(UIAlertAction(title: "Delete".localized(), style: .destructive, handler: { [weak self] _ in
                        do {
                            try RoadmapRepository.shared.deleteRoadmap(roadmap: self!.roadmaps[indexPath.row])
                        } catch {
                            print(error)
                        }
                        
                        self?.profileView.myRoadmapCollectionView.reloadData()
                    }))
                    action.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
                    action.view.tintColor = .accent
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
        profileView.emptyState()
        return roadmaps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var openRoadmap = roadmaps[indexPath.row]
        if openRoadmap.isShared {
            // chama o roadmap do back
            DataManager.shared.getRoadmapById(roadmapId: Int(roadmaps[indexPath.row].id)) { backRoadmap in
                openRoadmap = RoadmapRepository.shared.updateFromBackend(editRoadmap: self.roadmaps[indexPath.row], roadmap: backRoadmap)
                self.coordinator?.openRoadmap(roadmap: openRoadmap )
            }
            self.coordinator?.openRoadmap(roadmap: openRoadmap)
        } else {
            self.coordinator?.openRoadmap(roadmap: openRoadmap)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        let isNew = false
        cell.setup(name: roadmaps[indexPath.row].name ?? "Erro", image: roadmaps[indexPath.row].imageId ?? "mountain0", isNew: isNew)
        cell.setupImage(category: roadmaps[indexPath.row].category ?? "noCategory")
        cell.setupAnchors()
        return cell
    }
}
