//
//  MyTripViewControllerExtension.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit

// MARK: Setup
extension MyTripViewController {
    func setupMyTripView() {
        view.addSubview(myTripView)
        setupConstraints()
        
        let barItems = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMyTrip))
        barItems.tintColor = .accent
        self.navigationItem.rightBarButtonItem = barItems
        
    }
    func setupConstraints() {
        myTripView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: Collections - Delegate
extension MyTripViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            // button status
            cell.selectedButton()
            
            // select a day
            self.daySelected = indexPath.row
            self.days[daySelected].isSelected = true
            self.activites = getAllActivities()
            
            // view updates
            self.myTripView.activitiesTableView.reloadData()
            self.updateBudget()
            self.updateTotalBudgetValue()
        }
        
        // desabilita todas as celulas que nao sao a que recebeu o clique
        for index in 0..<roadmap.dayCount where index != indexPath.row {
            let newIndexPath = IndexPath(item: Int(index), section: 0)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? CalendarCollectionViewCell {
                self.days[Int(index)].isSelected = false
                cell.disable()
            }
        }
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
            switch indexPath.row {
            case 0:
                cell.title.text = "CATEGORY".localized()
                cell.circle.isHidden = false
                cell.categoryTitle.isHidden = false
                cell.categoryTitle.text = "Mountain".localized()
                cell.info.isHidden = true
                cell.circle.snp.makeConstraints { make in
                    make.height.width.equalTo(24)
                }

            case 1:
                cell.title.text = "TOTAL AMOUNT".localized()
                cell.info.isHidden = true
                cell.infoTitle.isHidden = false
                cell.infoTitle.text = "R$12.000"
            case 2:
                cell.title.text = "TRAVELERS".localized()
                cell.info.setTitle(" 4", for: .normal)
                cell.info.setImage(UIImage(systemName: "person.fill"), for: .normal)
            case 3:
                cell.title.text = "LIKES".localized()
                cell.info.setTitle(" 10k", for: .normal)
            case 4:
                cell.title.text = "CREATED BY".localized()
                cell.separator.isHidden = true
                cell.circle.isHidden = false
                cell.info.isHidden = true
                cell.circle.layer.cornerRadius = 18
                cell.circle.image = UIImage(named: "leisure")
                cell.circle.snp.makeConstraints { make in
                    make.height.width.equalTo(36)
                }
            default:
                break
            }
            
            cell.setupContent(roadmap: roadmap, indexPath: indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
                preconditionFailure("Cell not find")
                
            }
            cell.setDay(date: days[indexPath.row].date ?? "1")
            if days[indexPath.row].isSelected == true {
                cell.selectedButton()
            }
            return cell
        }
    }
}

// MARK: Table View Activities
extension MyTripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        cell.setupDaysActivities(hour: self.activites[indexPath.row].hour ?? "10h00",
                                 value: String(self.activites[indexPath.row].budget),
                                 name: self.activites[indexPath.row].name ?? "Nova atividade")
        cell.activityIcon.image = UIImage(named: self.activites[indexPath.row].category ?? "leisure")
        
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
        let copyArray = activites
        let mover = activites.remove(at: sourceIndexPath.row)
        activites.insert(mover, at: destinationIndexPath.row)

        for index in 0..<activites.count {
            activites[index].hour = copyArray[index].hour
        }
        
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
