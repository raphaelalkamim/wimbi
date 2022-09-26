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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        setup()
    }
}

extension CurrentViewController {
    func setup() {
        self.view.addSubview(currentEmptyView)
        setupConstraints()
    }
    
    func setupConstraints() {
        currentEmptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
