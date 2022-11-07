//
//  ReviewTravelViewControllerExtensions.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 04/11/22.
//

import Foundation
import UIKit

extension ReviewTravelViewController {
    func setupReviewTravelView() {
        navigationItem.title = "My roadmap".localized()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        reviewTravelView.coverImage.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        reviewTravelView.bindTableView(delegate: self, dataSource: self)
    }
    
    func setupToolbar() {
        let barItems = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelRoadmap))
        self.navigationItem.leftBarButtonItems = [barItems]
        
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = true
        toolBar.barStyle = .default
        toolBar.backgroundColor = designSystem.palette.backgroundCell
        
        let previous = UIBarButtonItem(title: "Previous".localized(), style: .plain, target: self, action: #selector(backPage))
        let next = UIBarButtonItem(title: "Next".localized(), style: .plain, target: self, action: #selector(nextPage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [spacer, previous, spacer, spacer, spacer, spacer, spacer, spacer, spacer, next, spacer]
        self.setToolbarItems(items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setupContent() {
        if edit { self.imageId = editRoadmap.imageId ?? "defaultCover" }
        self.daysCount = roadmap.dayCount
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "d/M/y"
        let date = dateFormat.date(from: roadmap.dateInitial)
        let dateFinal = dateFormat.date(from: roadmap.dateFinal)

        self.start = date ?? Date()
        self.final = dateFinal ?? Date()
        
        self.isPublic = roadmap.isPublic
        self.peopleCount = roadmap.peopleCount
        self.reviewTravelView.subtitle.text = self.roadmap.category
        self.reviewTravelView.title.text = self.roadmap.name
        self.reviewTravelView.setupCategory(category: roadmap.category)
        
        self.setupImage(imageId: self.imageId, category: roadmap.category)
    }
    
    func setupImage(imageId: String, category: String) {
        if imageId == "defaultCover" {
            self.reviewTravelView.setupImage(category: roadmap.category)
        } else {
            self.roadmap.imageId = editRoadmap.imageId ?? ""
            self.reviewTravelView.coverImage.setImageById(imageId: editRoadmap.imageId ?? "")
        }
    }
}
extension ReviewTravelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ReviewTravelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reviewTravelView.daysTable {
            return 3
        } else if tableView == reviewTravelView.travelersTable {
            return 1
        } else if tableView == reviewTravelView.privacyTitle {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .medium
        
        if tableView == reviewTravelView.daysTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                if indexPath.row == 0 {
                    newCell.configureDays(indexPath: 0, value: String(self.daysCount))
                    cell = newCell
                }
                if indexPath.row == 1 {
                    newCell.configureDays(indexPath: 1, value: format.string(from: self.start))
                    cell = newCell
                }
                if indexPath.row == 2 {
                    newCell.configureDays(indexPath: 2, value: format.string(from: self.final))
                    cell = newCell
                }
            }
        }
        if tableView == reviewTravelView.travelersTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTravelers(daysValue: self.peopleCount)
                cell = newCell
            }
        }
        if tableView == reviewTravelView.privacyTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTripStatus(isPublic: self.isPublic)
                cell = newCell
            }
        }
        return cell
    }
}

extension ReviewTravelViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let imageNew = image {
            self.imageSelected = imageNew
            self.reviewTravelView.coverImage.setBackgroundImage(imageNew, for: .normal)
            self.roadmap.imageId = SaveImagecontroller.saveToFiles(image: imageNew)
        }
    }
}
