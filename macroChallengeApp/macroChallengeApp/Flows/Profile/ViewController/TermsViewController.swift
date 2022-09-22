//
//  TermsViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import SnapKit

class TermsViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let termsView = TermsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupTermsView()
    }
}

extension TermsViewController {
    func setupTermsView() {
        view.addSubview(termsView)
        setupConstraints()
    }
    func setupConstraints() {
        termsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
