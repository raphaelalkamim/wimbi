//
//  ExploreViewController+PreviewRoadmap.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 26/09/22.
//

import Foundation
import UIKit

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
            return 14
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
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else {
                preconditionFailure("Cell not find")
            }
            cell.day.isHidden = true
            cell.dayButton.setTitle("1º", for: .normal)
            cell.dayButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            return cell
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
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as? ActivityTableViewCell else {
            fatalError("TableCell not found")
            
        }
        return cell
    }
}
