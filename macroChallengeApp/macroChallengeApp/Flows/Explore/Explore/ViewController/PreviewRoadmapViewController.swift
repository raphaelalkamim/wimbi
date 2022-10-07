//
//  PreviewRoadmapViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 26/09/22.
//

import Foundation
import UIKit

class PreviewRoadmapViewController: UIViewController {
    weak var coordinator: ExploreCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let previewView = PreviewRoadmapView()
    var like = UIBarButtonItem()
    var duplicate = UIBarButtonItem()
    var roadmapId: Int = 0
    var roadmap: Roadmaps = Roadmaps()
    var daySelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRoadmapById(roadmapId: self.roadmapId)
        
        self.view.backgroundColor = .backgroundPrimary
        self.setupPreviewRoadmapView()
        previewView.bindCollectionView(delegate: self, dataSource: self)
        previewView.bindTableView(delegate: self, dataSource: self)
//        like = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeRoadmap))
        duplicate = UIBarButtonItem(image: UIImage(systemName: "plus.square.on.square"), style: .plain, target: self, action: #selector(duplicateRoadmap))
        navigationItem.rightBarButtonItems = [duplicate]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .backgroundPrimary
        navigationController?.navigationBar.barTintColor = .backgroundPrimary
    }
    
    func getRoadmapById(roadmapId: Int) {
        DataManager.shared.getRoadmapById(roadmapId: roadmapId, { roadmap in
            self.previewView.cover.image = UIImage(named: roadmap.imageId)
            self.previewView.title.text = roadmap.name
            self.roadmap = roadmap
            self.roadmap.days.sort {
                $0.id < $1.id
            }
            self.roadmap.days[0].isSelected = true
            
            self.previewView.infoTripCollectionView.reloadData()
            self.previewView.calendarCollectionView.reloadData()
        })
    }

    @objc func likeRoadmap() {
        print("LIKE")
    }
    
    @objc func duplicateRoadmap() {
        print("DUPLICA")
    }
    
}
