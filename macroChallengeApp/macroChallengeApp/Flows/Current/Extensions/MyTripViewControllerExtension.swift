//
//  MyTripViewControllerExtension.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit

extension MyTripViewController {
    func setupMyTripView() {
        view.addSubview(myTripView)
        setupConstraints()
    }
    func setupConstraints() {
        myTripView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MyTripViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            cell.selectedButton(indexPath: indexPath.row, daysNumber: Int(roadmap.dayCount))
        }
        
        for index in 0..<roadmap.dayCount where index != indexPath.row {
            let newIndexPath = IndexPath(item: Int(index), section: 0)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? CalendarCollectionViewCell {
                cell.dayButton.backgroundColor = designSystem.palette.backgroundPrimary
                cell.dayButton.setTitleColor(designSystem.palette.textPrimary, for: .normal)
            }
        }
    }
   
}

extension MyTripViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myTripView.infoTripCollectionView {
            return 5
        } else {
            return Int(roadmap.dayCount)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myTripView.infoTripCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoTripCollectionViewCell.identifier, for: indexPath) as? InfoTripCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            cell.setupContent(roadmap: roadmap, indexPath: indexPath.row)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            cell.setupDays(startDay: roadmap.date ?? Date(), indexPath: indexPath.row)
            //cell.desable(indexPath: indexPath.row, daysNumber: Int(roadmap.dayCount))
            return cell
        }
    }
}

extension MyTripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MyTripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as? ActivityTableViewCell else {
            fatalError("TableCell not found")
            
        }
        return cell
    }
}
