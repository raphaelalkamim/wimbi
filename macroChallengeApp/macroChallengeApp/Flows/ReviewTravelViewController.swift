//
//  ReviewTravelViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 16/09/22.
//

import UIKit

class ReviewTravelViewController: UIViewController {
    let reviewTravelView = ReviewTravelView()
    var categoria: String = ""
    let designSystem = DefaultDesignSystem.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupReviewTravelView()
    }
    
    func setupReviewTravelView() {
        navigationItem.title = "Minha Viagem"
        self.view.addSubview(reviewTravelView)
        setupReviewConstraints()
        reviewTravelView.bindTableView(delegate: self, dataSource: self)
    }
    
    func setupReviewConstraints() {
        reviewTravelView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
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
        if tableView == reviewTravelView.daysTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                if indexPath.row == 0 {
                    newCell.configureDays(indexPath: 0, value: "5")
                    cell = newCell
                }
                if indexPath.row == 1 {
                    newCell.configureDays(indexPath: 1, value: "20 de outubro de 2022")
                    cell = newCell
                }
                if indexPath.row == 2 {
                    newCell.configureDays(indexPath: 2, value: "23 de outubro de 2022")
                    cell = newCell
                }
            }
        }
        if tableView == reviewTravelView.travelersTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTravelers(daysValue: 3)
                cell = newCell
            }
        }
        if tableView == reviewTravelView.privacyTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTripStatus(isPublic: true)
                cell = newCell
            }
        }
        return cell
    }
}
