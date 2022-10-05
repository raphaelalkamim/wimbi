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
        setupConstraints()
    }
    func setupConstraints() {
        previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PreviewRoadmapViewController: UICollectionViewDelegate {
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
            switch indexPath.row {
            case 0:
                cell.title.text = "CATEGORIA"
                cell.circle.isHidden = false
                cell.categoryTitle.isHidden = false
                cell.categoryTitle.text = self.roadmap.category
                cell.info.isHidden = true
                cell.circle.snp.makeConstraints { make in
                    make.height.width.equalTo(24)
                }
                
            case 1:
                cell.title.text = "VALOR TOTAL"
                cell.info.isHidden = true
                cell.infoTitle.isHidden = false
                cell.circle.isHidden = true
                cell.categoryTitle.isHidden = true
                cell.infoTitle.text = "\(self.roadmap.budget)"
            case 2:
                cell.title.text = "VIAJANTES"
                cell.info.isHidden = false
                cell.infoTitle.isHidden = true
                cell.info.setTitle(" \(self.roadmap.peopleCount)", for: .normal)
                cell.info.setImage(UIImage(systemName: "person.fill"), for: .normal)
            case 3:
                cell.title.text = "CURTIDAS"
                cell.info.setTitle(" 10k", for: .normal)
            case 4:
                cell.title.text = "CRIADO POR"
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
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
                preconditionFailure("Cell not find")
                
            }
            
            cell.setDay(date: self.roadmap.days[indexPath.row].date ?? "1")
            if self.roadmap.days[indexPath.row].isSelected == true {
                cell.selectedButton()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            // button status
            cell.selectedButton()
            
            // select a day
            self.daySelected = indexPath.row
            self.roadmap.days[daySelected].isSelected = true
            
            // view updates
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
        cell.setupDaysActivities(hour: activity.hour,
                                 value: String(activity.budget),
                                 name: activity.name)
        cell.activityIcon.image = UIImage(named: activity.category)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("fsfs")
    }
}
