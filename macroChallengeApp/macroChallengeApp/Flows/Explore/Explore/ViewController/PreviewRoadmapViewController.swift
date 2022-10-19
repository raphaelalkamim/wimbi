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
    weak var profileCoordinator: ProfileCoordinator?
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
                like = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeRoadmap))
        duplicate = UIBarButtonItem(image: UIImage(systemName: "plus.square.on.square"), style: .plain, target: self, action: #selector(duplicateRoadmap))
        navigationItem.rightBarButtonItems = [duplicate, like]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .backgroundPrimary
        navigationController?.navigationBar.barTintColor = .backgroundPrimary
    }
    
    func updateConstraintsTable() {
        let height = 100 * self.roadmap.days[daySelected].activity.count
        
        previewView.activitiesTableView.snp.removeConstraints()
        previewView.activitiesTableView.snp.makeConstraints { make in
            make.top.equalTo(previewView.roadmapTitle.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(previewView.contentView.snp.leading)
            make.trailing.equalTo(previewView.contentView.snp.trailing)
            make.bottom.equalTo(previewView.scrollView.snp.bottom)
            make.height.equalTo(height)
        }
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
            
            for index in 0..<self.roadmap.days.count {
                self.roadmap.days[index].activity.sort {
                    $0.id < $1.id
                }
            }
            
            self.previewView.infoTripCollectionView.reloadData()
            self.previewView.calendarCollectionView.reloadData()
            self.previewView.activitiesTableView.reloadData()
        })
    }
    
    @objc func likeRoadmap() {
        print("LIKE")
    }
    
    @objc func duplicateRoadmap() {
        print("DUPLICA")
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let string = NSAttributedString(string: "Successfully duplicated!".localized(), attributes: titleAtt)
        alert.setValue(string, forKey: "attributedTitle")
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let subtitleString = NSAttributedString(string: "The roadmap is now available on your profile.".localized(), attributes: subtitleAtt)
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        present(alert, animated: true)
        let newRoadmap = RoadmapRepository.shared.createRoadmap(roadmap: self.roadmap)
        let days = newRoadmap.day?.allObjects as [DayLocal]
        let roadmapDays = self.roadmap.days
        for index in 0..<roadmapDays.count {
            let activiyArray = roadmapDays[index].activity
            for activity in activiyArray {
                _ = ActivityRepository.shared.createActivity(day: days[index], activity: activity)
            }
        }
    }
}
