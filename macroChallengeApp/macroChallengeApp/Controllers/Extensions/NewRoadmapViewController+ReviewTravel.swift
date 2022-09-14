//
//  NewRoadmapViewController+ReviewTravel.swift
//  macroChallengeApp
//
//  Created by Juliana Santana on 14/09/22.
//

import Foundation
import UIKit
import SnapKit

extension NewRoadmapViewController {
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
