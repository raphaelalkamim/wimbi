//
//  ExploreViewController+PreviewRoadmap.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 26/09/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol DismissBlurExplore: AnyObject {
    func dismissBlur()
}

extension PreviewRoadmapViewController {
    func setupPreviewRoadmapView() {
        view.addSubview(previewView)
        
        previewView.bindCollectionView(delegate: self, dataSource: self)
        previewView.bindTableView(delegate: self, dataSource: self)
        setupNavControl()
        setupConstraints()
        updateConstraintsTable()
        
        if tutorialEnable == false { self.previewView.animateCollection() }
    }
    
    func setupNavControl() {
        like = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeRoadmap))
        duplicate = UIBarButtonItem(image: UIImage(systemName: "plus.square.on.square"), style: .plain, target: self, action: #selector(duplicateRoadmap))
        
        navigationItem.rightBarButtonItems = [duplicate, like]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .backgroundPrimary
        navigationController?.navigationBar.barTintColor = .backgroundPrimary
    }
    
    func setupConstraints() {
        previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func addRoute(sender: UIButton) {
        let activity = self.roadmap.days[self.daySelected].activity[sender.tag]
        let coordsSeparated = activity.location.split(separator: " ")
        
        let latitude = String(coordsSeparated[0])
        let longitude = String(coordsSeparated[1])
        
        let googleURL = "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)"
        
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        let googleItem = ("Google Maps", URL(string: googleURL)!)
        let wazeItem = ("Waze", URL(string: wazeURL)!)
        var installedNavigationApps: [(String, URL)] = []
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.view.tintColor = .accent
        
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 15)]
        let string = NSAttributedString(string: "Which app would you like to use to access the address?".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        
        alert.setValue(string, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Open on Maps".localized(), style: .default, handler: { _ in
            let coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude) ?? 0, longitude: CLLocationDegrees(longitude) ?? 0)
            let placemark = MKPlacemark(coordinate: coords)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Target Location"
            mapItem.openInMaps(launchOptions: [:])
        }))
        
        for app in installedNavigationApps {
            let title = "Open on".localized()
            let button = UIAlertAction(title: "\(title) \(app.0)", style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        
        present(alert, animated: true)
        
    }
    // MARK: Alerts
    func loginAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let string = NSAttributedString(string: "Login required".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(string, forKey: "attributedTitle")
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let subtitleString = NSAttributedString(string: "Access the profile and log-in to duplicate or create new itineraries".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        present(alert, animated: true)
    }
    func duplicateAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.tintColor = .accent
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 18)]
        let string = NSAttributedString(string: "Successfully duplicated!".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        alert.setValue(string, forKey: "attributedTitle")
        let subtitleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 14)]
        let subtitleString = NSAttributedString(string: "The itinerary is now available on your profile.".localized(), attributes: subtitleAtt as [NSAttributedString.Key: Any])
        alert.setValue(subtitleString, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        present(alert, animated: true)
        roadmap.likesCount = 0
        roadmap.imageId = "defaultCover"
        let newRoadmap = RoadmapRepository.shared.createRoadmap(roadmap: self.roadmap, isNew: false)
        guard let days = newRoadmap.day?.allObjects as? [DayLocal] else { return }
        let roadmapDays = self.roadmap.days
        for index in 0..<roadmapDays.count {
            let activiyArray = roadmapDays[index].activity
            for activity in activiyArray {
                _ = ActivityRepository.shared.createActivity(day: days[index], activity: activity, isNew: true)
            }
        }
        FirebaseManager.shared.createAnalyticsEvent(event: "duplicate_roadmap", parameters: ["roadmap_id": self.roadmap.id])
    }
}
// MARK: - CollectionView
extension PreviewRoadmapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // desabilita todas as celulas que nao sao a que recebeu o clique
        for index in 0..<roadmap.dayCount where index != indexPath.row {
            self.roadmap.days[Int(index)].isSelected = false
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            // button status
            cell.selectedButton()
            // select a day
            self.daySelected = indexPath.row
            previewView.emptyState(activities: roadmap.days[self.daySelected].activity)
            self.roadmap.days[daySelected].isSelected = true
            // view updates
            updateConstraintsTable()
            self.previewView.activitiesTableView.reloadData()
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            cell.disable()
        }
    }
}
extension PreviewRoadmapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == previewView.infoTripCollectionView {
            return 5
        } else {
            return self.roadmap.days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == previewView.infoTripCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoTripCollectionViewCell.identifier, for: indexPath) as? InfoTripCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            cell.setupContentCell(roadmap: roadmap, indexPath: indexPath.row, userCurrency: self.userCurrency, uuidImage: self.uuidImage)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            cell.setDay(date: self.roadmap.days[indexPath.row].date)
            cell.dayButton.setTitle("\(indexPath.row + 1)º", for: .normal)
            if self.roadmap.days[indexPath.row].isSelected == true {
                cell.selectedButton()
            } else { cell.disable() }
            return cell
        }
    }
    func setupColor(category: String) -> UIColor {
        if category == "Beach" {
            return .blueBeach
        } else if category == "Mountain" {
            return .yellowMontain
        } else if category == "City" {
            return .redCity
        } else {
            return .greenCamp
        }
    }
}
// MARK: - TableView
extension PreviewRoadmapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension PreviewRoadmapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roadmap.days[self.daySelected].activity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as? ActivityTableViewCell else {
            fatalError("TableCell not found")
        }
        let activity = roadmap.days[self.daySelected].activity[indexPath.row]
        cell.localButton.tag = indexPath.row
        if activity.location.isEmpty { cell.localButton.isHidden = true
        } else { cell.localButton.isHidden = false }
        cell.localButton.addTarget(self, action: #selector(addRoute(sender:)), for: .touchUpInside)
        cell.setupDaysActivities(hour: activity.hour, currency: activity.currency,
                                 value: String(activity.budget),
                                 name: activity.name)
        cell.activityIcon.image = UIImage(named: activity.category)
        // self.updateAllBudget()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = self.roadmap.days[daySelected].activity[indexPath.row]
        self.coordinator?.showActivitySheet(tripVC: self, activity: activity)
        previewView.transparentView.isHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor(white: 0, alpha: 0.001)
    }
}

extension PreviewRoadmapViewController: DismissBlurExplore {
    func dismissBlur() {
        previewView.transparentView.isHidden = true
    }
}
