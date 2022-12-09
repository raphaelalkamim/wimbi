//
//  MyTripViewControllerExtension.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol DismissBlur: AnyObject {
    func dismissBlur()
}

// MARK: Setup
extension MyTripViewController {
    func setupMyTripView() {
        // se estiver visualizando a viagem e estiver conectado
        network.startMonitoring()
        if coordinator != nil && network.isReachable {
            let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMyTrip))
            editItem.tintColor = .accent
            let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMyTrip))
            self.navigationItem.rightBarButtonItems = [shareItem, editItem]
            myTripView.addButton.isHidden = false
            myTripView.addButton.addTarget(self, action: #selector(goToCreateActivity), for: .touchUpInside)
        }
        
        myTripView.setupContent(roadmap: roadmap)
        myTripView.bindCollectionView(delegate: self, dataSource: self)
        myTripView.bindTableView(delegate: self, dataSource: self, dragDelegate: self)
        
        if tutorialEnable == false {
            if (coordinatorCurrent != nil) {
                myTripView.animateCollection(index: 2)
            } else {
                myTripView.animateCollection(index: 3)
            }
        }
    }
    
    @objc func addRoute(sender: UIButton) {
        let activity = activites[sender.tag]
        if activity.location != nil {
            let coordsSeparated = activity.location?.split(separator: " ")
            if let coordsSeparated = coordsSeparated {
                let latitude = String(coordsSeparated[0])
                let longitude = String(coordsSeparated[1])
                
                let googleURL = "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"
                
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
                
                let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 16)]
                let string = NSAttributedString(string: "Which app would you like to use to access the address?".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
                
                alert.setValue(string, forKey: "attributedTitle")
                
                alert.addAction(UIAlertAction(title: "Open on Maps".localized(), style: .default, handler: { _ in
                    let coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude) ?? 0, longitude: CLLocationDegrees(longitude) ?? 0)
                    let placemark = MKPlacemark(coordinate: coords)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = "Target Location"
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                }))
                
                for app in installedNavigationApps {
                    let title = "Open on".localized()
                    let button = UIAlertAction(title: "\(title) \(app.0)", style: .default, handler: { _ in
                        UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
                    })
                    alert.addAction(button)
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
                }))
                
                present(alert, animated: true)
            }
            
        }
    }
}

// MARK: Collections - Delegate
extension MyTripViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // desabilita todas as celulas que nao sao a que recebeu o clique
        for daysCallendar in days {
            daysCallendar.isSelected = false
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            // button status
            cell.selectedButton()
            
            // select a day
            self.getAllDays()
            self.daySelected = indexPath.row
            self.days[daySelected].isSelected = true
            self.activites = getAllActivities()
            self.emptyState(activities: activites)
            
            // view updates
            self.myTripView.updateConstraintsTable(multiplier: activites.count)
            self.myTripView.activitiesTableView.reloadData()
            Task {
                await currencyController.updateBudget(activites: activites, userCurrency: self.userCurrency)
            }
            self.updateTotalBudgetValue()
        }
        collectionView.reloadData()
        self.updateAllBudget()
        RoadmapRepository.shared.saveContext()
    }
}

// MARK: Collections - Data Source
extension MyTripViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myTripView.infoTripCollectionView {
            return 5
        } else {
            return Int(days.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myTripView.infoTripCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoTripCollectionViewCell.identifier, for: indexPath) as? InfoTripCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            cell.setupContent(roadmap: roadmap, indexPath: indexPath.row, user: self.user[0])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            cell.setDay(date: days[indexPath.row].date ?? "1")
            if days[indexPath.row].isSelected == true {
                cell.selectedButton()
                
            } else { cell.disable() }
            return cell
        }
    }
}

// MARK: Table View Activities
extension MyTripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = self.activites[indexPath.row]

        self.coordinator?.showActivitySheet(tripVC: self, activity: activity)
        self.coordinatorCurrent?.showActivitySheet(tripVC: self, activity: activity)
        navigationController?.navigationBar.backgroundColor = UIColor(white: 0, alpha: 0.001)
        myTripView.transparentView.isHidden = false
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: "Edit".localized()) { [weak self] _, _, completionHandler in
            self!.coordinator?.editActivity(roadmap: self!.roadmap, day: self!.days[self!.daySelected], delegate: self!, activity: self!.activites[indexPath.row])
            self!.coordinatorCurrent?.editActivity(roadmap: self!.roadmap, day: self!.days[self!.daySelected], delegate: self!, activity: self!.activites[indexPath.row])
            completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete".localized()) { [weak self] _, _, completionHandler in
            self?.deleteItem(indexPath: indexPath, tableView: tableView)
            self?.updateAllBudget()
            completionHandler(true)
        }
        editAction.backgroundColor = .blueBeach
        deleteAction.backgroundColor = .redCity
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func deleteItem(indexPath: IndexPath, tableView: UITableView) {
        do {
            try ActivityRepository.shared.deleteActivity(activity: activites[indexPath.row])
            activites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } catch {
            print("erro ao deletar")
        }
        myTripView.infoTripCollectionView.reloadItems(at: [IndexPath(item: 0, section: 1)])
    }
}

extension MyTripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as? ActivityTableViewCell else {
            fatalError("TableCell not found")
        }
        cell.localButton.tag = indexPath.row
        cell.localButton.addTarget(self, action: #selector(addRoute(sender:)), for: .touchUpInside)
        cell.setupDaysActivities(hour: self.activites[indexPath.row].hour ?? "10h00",
                                 currency: self.activites[indexPath.row].currencyType ?? "U$",
                                 value: String(self.activites[indexPath.row].budget),
                                 name: self.activites[indexPath.row].name ?? "Nova atividade")
        cell.setupCategoryImage(image: self.activites[indexPath.row].category ?? "empty")
        if self.activites[indexPath.row].location?.isEmpty == true {
            cell.localButton.isHidden = true
        } else {
            cell.localButton.isHidden = false
        }

        return cell
     
    }
    
}

// MARK: Drag and drop
extension MyTripViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = activites[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var hoursBefore: [String] = []
        for activity in activites {
            if let hour = activity.hour {
                hoursBefore.append(hour)
            }
        }
        
        let mover = activites.remove(at: sourceIndexPath.row)
        activites.insert(mover, at: destinationIndexPath.row)
        
        for index in 0..<activites.count {
            activites[index].hour = hoursBefore[index]
        }
        
        ActivityRepository.shared.saveContext()
        tableView.reloadData()
    }
}

// MARK: Delegate
extension MyTripViewController: AddNewActivityDelegate {
    func attTable() {
        self.activites = getAllActivities()
        myTripView.activitiesTableView.reloadData()
    }
}

extension MyTripViewController: DismissBlur {
    func dismissBlur() {
        myTripView.transparentView.isHidden = true
    }
    
}
