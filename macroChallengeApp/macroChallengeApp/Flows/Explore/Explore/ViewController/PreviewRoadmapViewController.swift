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
    var likeId = 0
    let tutorialEnable = UserDefaults.standard.bool(forKey: "tutorialExplore")

    var budgetTotal: Double = 0
    let currencyController = CurrencyController()
    
    lazy var userCurrency: String = {
        let userC = currencyController.getUserCurrency()
        return userC
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        getRoadmapById(roadmapId: self.roadmapId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAllBudget()
        self.setupPreviewRoadmapView()
        
        previewView.tutorialTitle.addTarget(self, action: #selector(tutorial), for: .touchUpInside)
        
        if tutorialEnable == false {
            self.tutorialTimer()
        }
        
        DataManager.shared.getLike(roadmapId: self.roadmapId) { response in
            self.likeId = response
            if self.likeId == 0 {
                print("Not Liked")
            } else {
                print("Liked")
                self.like.image = UIImage(systemName: "heart.fill")
            }
        }
    }
    
    func tutorialTimer() {
        UserDefaults.standard.set(true, forKey: "tutorialExplore")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.previewView.tutorialView.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            self.previewView.tutorialView.removeFromSuperview()
        }
    }
    
    @objc func tutorial() {
        UserDefaults.standard.set(true, forKey: "tutorialExplore")
        previewView.tutorialView.removeFromSuperview()
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
            self.roadmap = roadmap
            self.setupContent(roadmap: roadmap)
        })
    }
    
    func setupContent(roadmap: Roadmaps) {
        self.previewView.cover.image = UIImage(named: roadmap.imageId)
        self.previewView.title.text = roadmap.name
        self.roadmap.days.sort {
            $0.id < $1.id
        }
        self.roadmap.days[0].isSelected = true
        for index in 0..<self.roadmap.days.count {
            self.roadmap.days[index].activity.sort {
                $0.hour < $1.hour
            }
        }
        self.previewView.infoTripCollectionView.reloadData()
        self.previewView.calendarCollectionView.reloadData()
        self.previewView.activitiesTableView.reloadData()
    }
    
    @objc func likeRoadmap() {
        if self.likeId == 0 {
            self.like.image = UIImage(systemName: "heart.fill")
            DataManager.shared.postLike(roadmapId: self.roadmapId) { response in
                self.likeId = response
                if self.likeId == 0 {
                    print("Not Liked")
                } else {
                    print("Liked")
                    self.like.image = UIImage(systemName: "heart.fill")
                }
            }
            
        } else {
            self.like.image = UIImage(systemName: "heart")
            DataManager.shared.deleteObjectBack(objectID: self.likeId, urlPrefix: "likes")
            self.likeId = 0
        }
        print("LIKE")
    }
    
    @objc func duplicateRoadmap() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let string = NSAttributedString(string: "Successfully duplicated!".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(string, forKey: "attributedTitle")
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let subtitleString = NSAttributedString(string: "The roadmap is now available on your profile.".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        present(alert, animated: true)
        let newRoadmap = RoadmapRepository.shared.createRoadmap(roadmap: self.roadmap, isNew: false)
        let days = newRoadmap.day?.allObjects as [DayLocal]
        let roadmapDays = self.roadmap.days
        for index in 0..<roadmapDays.count {
            let activiyArray = roadmapDays[index].activity
            for activity in activiyArray {
                _ = ActivityRepository.shared.createActivity(day: days[index], activity: activity, isNew: true)
            }
        }
    }
    func updateAllBudget() {
        Task {
            await budgetTotal = currencyController.updateBudgetTotal(userCurrency: self.userCurrency, days: self.roadmap.days)
            roadmap.budget = budgetTotal
            RoadmapRepository.shared.saveContext()
            self.updateTotalBudgetValue()
        }
    }
    func updateTotalBudgetValue() {
        guard let cell = previewView.infoTripCollectionView.cellForItem(at: [0, 1]) as? InfoTripCollectionViewCell else { return }
        cell.infoTitle.text = "\(self.userCurrency)\(self.budgetTotal)"
    }
}
