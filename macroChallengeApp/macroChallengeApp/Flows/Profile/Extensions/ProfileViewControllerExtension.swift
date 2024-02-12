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
        self.setupGestures()
        self.setupNavButton()
        profileView.updateConstraintsCollection()
        profileView.bindColletionView(delegate: self, dataSource: self)
    }
    
    func setupGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        profileView.myRoadmapCollectionView.addGestureRecognizer(longPress)
    }
    
    func setupNavButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileSettings))
    }
    
    // MARK: Long press and delete
    @objc public func handleLongPress(sender: UILongPressGestureRecognizer) {
        network.startMonitoring()
        if sender.state == .began {
            let touchPoint = sender.location(in: profileView.myRoadmapCollectionView)
            if let indexPath = profileView.myRoadmapCollectionView.indexPathForItem(at: touchPoint) {
                if roadmaps.isEmpty || !network.isReachable {
                    present(RoadmapAlertController.cantDelete(handler: self.profileView.myRoadmapCollectionView.reloadData()), animated: true)
                } else {
                    present(RoadmapAlertController.deleteRoadmap(roadmap: roadmaps[indexPath.item], handler: self.getContent()), animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.getContent()
                        print("atualizar tabela")
                    }
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
        let openRoadmap = roadmaps[indexPath.row]
        DataManager.shared.getRoadmapById(roadmapId: Int(openRoadmap.id)) { backRoadmap in
            if let backRoadmap = backRoadmap {
                self.coordinator?.openRoadmap(roadmap: backRoadmap )
            } else {
                self.coordinator?.showAlertController(alert: RoadmapAlertController.roadmapsHasBeenDeleted())
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        
        let isNew = false
        UserDefaults.standard.bool(forKey: "isPublic")
        cell.setup(name: roadmaps[indexPath.row].name,
                   image: roadmaps[indexPath.row].imageId,
                   isNew: isNew)
        cell.setupImage(imageId: roadmaps[indexPath.row].imageId,
                        category: roadmaps[indexPath.row].category )
        
        //        if roadmaps[indexPath.row].isPublic == false {
        //            cell.likeImage.image = UIImage(systemName: "lock.fill")
        //            UserDefaults.standard.set(false, forKey: "isPublic")
        //            cell.likeLabel.isHidden = true
        //        } else {
        //            cell.likeLabel.isHidden = false
        //            UserDefaults.standard.set(true, forKey: "isPublic")
        //            cell.likeImage.image = UIImage(systemName: "heart.fill")
        //            cell.likeLabel.text = String(roadmaps[indexPath.row].likesCount)
        //        }
        cell.setupAnchors()
        print("roadmaps.cell\(cell.title)")
        return cell
    }
}
