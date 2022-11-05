//
//  DetailViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 25/10/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let detailView = DetailView()
    let myTripView = MyTripView()
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    weak var delegate: DismissBlur?
    weak var delegateExplore: DismissBlurExplore?
    var activity = ActivityLocal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        setupDetailView()
        detailView.linkButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismissBlur()
        delegateExplore?.dismissBlur()
    }
    
    @objc func openLink() {
        let text = detailView.linkButton.titleLabel?.text
        UIApplication.shared.openURL(NSURL(string: text ?? "http://www.google.com")! as URL)
    }
}

extension DetailViewController {
    func setupDetailView() {
        view.addSubview(detailView)
        setupConstraints()
    }
        
    func setupConstraints() {
        detailView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
}
