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
}

extension MyTripViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myTripView.infoTripCollectionView {
            return 5
        } else {
            return 14
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myTripView.infoTripCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoTripCollectionViewCell.identifier, for: indexPath) as? InfoTripCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            switch indexPath.row {
            case 0:
                cell.title.text = "CATEGORIA"
                cell.circle.isHidden = false
                cell.categoryTitle.isHidden = false
                cell.categoryTitle.text = "Montanha"
                cell.info.isHidden = true
                cell.circle.snp.makeConstraints { make in
                    make.height.width.equalTo(24)
                }

            case 1:
                cell.title.text = "VALOR TOTAL"
                cell.info.isHidden = true
                cell.infoTitle.isHidden = false
                cell.infoTitle.text = "R$12.000"
            case 2:
                cell.title.text = "VIAJANTES"
                cell.info.setTitle(" 4", for: .normal)
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
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            cell.selectedBackgroundView()
        }

    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            cell.notSelectedBackgroundView()
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
        return activites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as? ActivityTableViewCell else {
            fatalError("TableCell not found")
            
        }
        cell.activityTitle.text = activites[indexPath.row].name
        cell.activityInfo.text = "\(activites[indexPath.row].hour)  •  \(activites[indexPath.row].budget)"
        cell.activityTitle.text = activites[indexPath.row].name
        
        return cell
    }
}

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
