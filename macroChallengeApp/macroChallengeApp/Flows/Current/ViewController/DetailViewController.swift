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
    var roadmap = RoadmapLocal()
    var day = DayLocal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        setupDetailView()
        detailView.editButton.addTarget(self, action: #selector(editMyTrip), for: .touchUpInside)
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
        if let text = detailView.linkButton.titleLabel?.text {
            if text.contains("https://") || text.contains("http://") {
                UIApplication.shared.open(URL(string: text )! as URL)
            } else {
                UIApplication.shared.open(URL(string: "https://www.instagram.com/wimbi.app/")! as URL)
            }
        }
    }
    
    @objc func editMyTrip() {
        self.dismiss(animated: true)
        coordinator?.editActivity(roadmap: self.roadmap, day: self.day, delegate: delegate as? MyTripViewController ?? MyTripViewController(), activity: self.activity)
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
