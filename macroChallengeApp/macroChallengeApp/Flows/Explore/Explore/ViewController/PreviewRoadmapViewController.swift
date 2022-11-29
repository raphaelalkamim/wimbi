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
    var days: [Day] = []
    var daySelected = 0
    var likeId = 0
    let tutorialEnable = UserDefaults.standard.bool(forKey: "tutorialExplore")
    var uuidImage = ""
    var budgetTotal: Double = 0
    let currencyController = CurrencyController()
    
    lazy var userCurrency: String = {
        let userC = currencyController.getUserCurrency()
        return userC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRoadmapById(roadmapId: self.roadmapId)
        self.setupPreviewRoadmapView()
        
        previewView.tutorialTitle.addTarget(self, action: #selector(tutorial), for: .touchUpInside)
        
        if tutorialEnable == false {
            self.tutorialTimer()
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
            if let roadmap = roadmap {
                self.roadmap = roadmap
                self.setupContent(roadmap: roadmap)
            }
            self.days = self.roadmap.days
            self.days.sort { $0.date < $1.date }
            self.previewView.infoTripCollectionView.reloadData()
            self.previewView.calendarCollectionView.reloadData()
            self.previewView.activitiesTableView.reloadData()
        })
        
        DataManager.shared.getRoadmapUserImage(roadmapId: self.roadmapId) { uuidUser, username in
            print(uuidUser, username)
            self.previewView.username.text = "@\(username)".lowercased()
            // self.previewView.username.textColor = .accent
            self.uuidImage = uuidUser
            FirebaseManager.shared.getImage(category: 1, uuid: self.uuidImage) { _ in
            }
            self.previewView.hiddenSpinner()
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
    
    func setupContent(roadmap: Roadmaps) {
        if let cachedImage = FirebaseManager.shared.imageCash.object(forKey: NSString(string: roadmap.imageId)) {
            self.previewView.cover.image = cachedImage
        } else { self.previewView.cover.image = UIImage(named: ("\(roadmap.category)Cover")) }
        self.previewView.title.text = roadmap.name
        self.roadmap.days.sort { $0.id < $1.id }
        self.roadmap.days[0].isSelected = true
        for index in 0..<self.roadmap.days.count {
            self.roadmap.days[index].activity.sort { $0.hour < $1.hour }
        }
        self.updateAllBudget()
        updateConstraintsTable()
    }
    
    @objc func likeRoadmap() {
        if self.likeId == 0 {
            self.like.image = UIImage(systemName: "heart.fill")
            DataManager.shared.postLike(roadmapId: self.roadmapId) { response in
                self.likeId = response
                if self.likeId == 0 {
                    print("Not Liked")
                } else {
                    self.like.image = UIImage(systemName: "heart.fill")
                }
            }
        } else {
            self.like.image = UIImage(systemName: "heart")
            DataManager.shared.deleteObjectBack(objectID: self.likeId, urlPrefix: "likes")
            self.likeId = 0
        }
    }
    
    @objc func duplicateRoadmap() {
        let user = UserRepository.shared.getUser()
        if user.isEmpty {
            self.loginAlert()
        } else {
            self.duplicateAlert()
        }
        
    }
    func updateAllBudget() {
        Task {
           // await budgetTotal = currencyController.updateBudgetTotal(userCurrency: self.userCurrency, days: self.roadmap.days)
            await budgetTotal = currencyController.updateRoadmapTotalBudget(userCurrency: self.userCurrency, budget: roadmap.budget, outgoinCurrency: roadmap.currency)
            roadmap.budget = budgetTotal
            self.updateTotalBudgetValue()
        }
    }
    func updateTotalBudgetValue() {
        guard let cell = previewView.infoTripCollectionView.cellForItem(at: [0, 1]) as? InfoTripCollectionViewCell else { return }
        
        let content = String(format: "\(self.userCurrency)%.2f", self.budgetTotal)
        cell.infoTitle.text = content
        previewView.infoTripCollectionView.reloadData()
    }
}
