//
//  CurrentViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

class CurrentViewController: UIViewController {
    weak var coordinator: CurrentCoordinator?
    let currentEmptyView = CurrentEmptyState()
    let currentCountDownView = CurrentCountDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        setup()
    }
}

extension CurrentViewController {
    func setup() {
        setupCountDownView()
        // setupEmptyView()
    }
    
    func setupCountDownView() {
        self.view.addSubview(currentCountDownView)
        currentCountDownView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupEmptyView() {
        self.view.addSubview(currentEmptyView)
        currentEmptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
