//
//  ReviewTravelViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 16/09/22.
//

import UIKit
import PhotosUI

protocol ReviewTravelDelegate: AnyObject {
    func updateRoadmapScreen(roadmap: RoadmapLocal)
}

class ReviewTravelViewController: UIViewController {
    weak var coordinator: NewRoadmapCoordinator?

    let reviewTravelView = ReviewTravelView()
    let designSystem = DefaultDesignSystem.shared
    var dataManager = DataManager.shared
    var imagePicker: ImagePicker!
    var access = false
    
    var roadmap: Roadmaps
    var category = ""
    var location = ""
    var daysCount = 1
    var start = Date()
    var final = Date()
    var peopleCount = 1
    var isPublic = false
    var imageId = "defaultCover"
    var imageSelected: UIImage?
    var editRoadmap = RoadmapLocal()
    var edit = false
    
    weak var delegateRoadmap: ReviewTravelDelegate?
    
    override func loadView() {
        view = reviewTravelView
    }
    
    init(roadmap: Roadmaps) {
        self.roadmap = roadmap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupReviewTravelView()
        self.setupToolbar()
        self.setupContent()
    }
    @objc func nextPage() {
        if let imageSelected = imageSelected {
            if self.roadmap.imageId.contains(".jpeg") {
                FirebaseManager.shared.deleteImage(category: 0, uuid: roadmap.imageId)
            }
            self.roadmap.imageId = SaveImagecontroller.saveToFiles(image: imageSelected)
        }
        if edit {
            self.updateCoreData()
            NotificationManager.shared.registerTripNotification(roadmap: self.editRoadmap)
        } else {
            self.saveCoreData()
        }
        UIAccessibility.post(notification: .screenChanged, argument: coordinator?.navigationController)
        coordinator?.dismiss(isNewRoadmap: true)
    }
    func updateCoreData() {
        roadmap.currency = getUserCurrency()
        roadmap.budget = editRoadmap.budget
        let newRoadmap = RoadmapRepository.shared.updateRoadmap(editRoadmap: self.editRoadmap, roadmap: self.roadmap, isShared: false, selectedImage: imageSelected)
        delegateRoadmap?.updateRoadmapScreen(roadmap: newRoadmap)
    }
    func saveCoreData() {
        roadmap.currency = getUserCurrency()
        // save in Core Data
        let newRoadmap = RoadmapRepository.shared.createRoadmap(roadmap: self.roadmap, isNew: true, selectedImage: imageSelected)
        RoadmapRepository.shared.saveContext()
        
        NotificationManager.shared.registerTripNotification(roadmap: newRoadmap)
    }
    func setupDays(startDay: Date, indexPath: Int, isSelected: Bool) -> Day {
        let date = startDay.addingTimeInterval(Double(indexPath) * 24 * 3600)
        var day = Day(isSelected: isSelected, date: date)
        day.id = indexPath
        return day
    }
    
    func getUserCurrency() -> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        if currencySymbol == "$" {
            return "U$"
        } else {
            return currencySymbol ?? "U$"
        }
    }
    @objc func editPhoto(_ sender: Any) {
        let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status != .denied {
                        self.access = true

                    } else {
                        self.access = false
                    }
                })
            } else {
            let authorization = PHPhotoLibrary.authorizationStatus()
            if authorization != .denied {
                self.imagePicker.present(from: self.reviewTravelView)
            } else {
                print("Nao permitido")
            }
        }
    }
    @objc func backPage() {
        coordinator?.back()
    }
    @objc func cancelRoadmap() {
        coordinator?.dismissRoadmap(isNewRoadmap: false)
    }
}
