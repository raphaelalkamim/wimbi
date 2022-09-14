//
//  NewRoadmapViewController+ReviewTravel.swift
//  macroChallengeApp
//
//  Created by Juliana Santana on 14/09/22.
//

import Foundation
import UIKit
import SnapKit

extension NewRoadmapViewController{
    func setupReviewTravelView(){
        self.view.addSubview(reviewTravelView)
        setupReviewConstraints()
    }
    
    func setupReviewConstraints() {
        reviewTravelView.snp.makeConstraints{ make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
