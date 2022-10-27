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

extension PreviewRoadmapViewController {
    func setupPreviewRoadmapView() {
        view.addSubview(previewView)
        previewView.bindCollectionView(delegate: self, dataSource: self)
        previewView.bindTableView(delegate: self, dataSource: self)
        setupNavControl()
        setupConstraints()
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
}

extension PreviewRoadmapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            // button status
            cell.selectedButton()
            // select a day
            self.daySelected = indexPath.row
            self.roadmap.days[daySelected].isSelected = true
            
            // view updates
            updateConstraintsTable()
            
            self.previewView.activitiesTableView.reloadData()
        }
        
        // desabilita todas as celulas que nao sao a que recebeu o clique
        for index in 0..<roadmap.dayCount where index != indexPath.row {
            let newIndexPath = IndexPath(item: Int(index), section: 0)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? CalendarCollectionViewCell {
                self.roadmap.days[Int(index)].isSelected = false
                cell.disable()
            }
        }
    }
}
// MARK: CollectionView
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
            switch indexPath.row {
            case 0:
                cell.title.text = "CATEGORY".localized()
                cell.circle.isHidden = false
                cell.categoryTitle.isHidden = false
                cell.categoryTitle.text = self.roadmap.category.localized()
                print(self.roadmap.category)
                cell.circle.backgroundColor = setupColor(category: self.roadmap.category)
                cell.info.isHidden = true
                cell.circle.snp.makeConstraints { make in
                    make.height.width.equalTo(24)
                }
                
            case 1:
                cell.title.text = "TOTAL AMOUNT".localized()
                cell.info.isHidden = true
                cell.infoTitle.isHidden = false
                cell.circle.isHidden = true
                cell.categoryTitle.isHidden = true
                cell.infoTitle.text = "R$ \(self.roadmap.budget)"
            case 2:
                cell.title.text = "TRAVELERS".localized()
                cell.info.isHidden = false
                cell.infoTitle.isHidden = true
                cell.info.setTitle(" \(self.roadmap.peopleCount)", for: .normal)
                cell.info.setImage(UIImage(systemName: "person.fill"), for: .normal)
            case 3:
                cell.title.text = "LIKES".localized()
                cell.info.setTitle(" \(roadmap.likesCount)", for: .normal)
            case 4:
                cell.title.text = "CREATED BY".localized()
                cell.separator.isHidden = true
                cell.circle.isHidden = false
                cell.info.isHidden = true
                cell.circle.layer.cornerRadius = 18
                cell.circle.image = UIImage(named: "icon")
                cell.circle.snp.makeConstraints { make in
                    make.height.width.equalTo(36)
                }
            default:
                break
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
                preconditionFailure("Cell not find")
                
            }
            
            cell.setDay(date: self.roadmap.days[indexPath.row].date)
            cell.dayButton.setTitle("\(indexPath.row + 1)º", for: .normal)
            if self.roadmap.days[indexPath.row].isSelected == true {
                cell.selectedButton()
            }
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
// MARK: TableView
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
        if activity.location == "" {
            cell.localButton.isHidden = true
        }
        cell.localButton.addTarget(self, action: #selector(addRoute(sender:)), for: .touchUpInside)
        cell.setupDaysActivities(hour: activity.hour, currency: activity.currency,
                                 value: String(activity.budget),
                                 name: activity.name)
        cell.activityIcon.image = UIImage(named: activity.category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("fsfs")
    }
}
