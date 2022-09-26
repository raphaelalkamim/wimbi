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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupPreviewRoadmapView()
        previewView.bindCollectionView(delegate: self, dataSource: self)
        previewView.bindTableView(delegate: self, dataSource: self)
        like = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeRoadmap))
        duplicate = UIBarButtonItem(image: UIImage(systemName: "plus.square.on.square"), style: .plain, target: self, action: #selector(duplicateRoadmap))
        navigationItem.rightBarButtonItems = [duplicate, like]

    }
    
    @objc func likeRoadmap() {
        print("LIKE")
    }
    
    @objc func duplicateRoadmap() {
        print("DUPLICA")
    }
    
}
