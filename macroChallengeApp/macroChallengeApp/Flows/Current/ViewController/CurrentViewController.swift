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
    var roadmaps = RoadmapRepository.shared.getRoadmap()
    var roadmap: RoadmapLocal = RoadmapLocal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        roadmaps.sort {
            $0.date ?? Date() < $1.date ?? Date()
        }
        setup()
    }
}

extension CurrentViewController {
    func setup() {
        if !roadmaps.isEmpty {
            roadmap = roadmaps[0]
            configCountDown()
            setupCountDownView()

        } else {
            setupEmptyView()
        }
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
    
    func configCountDown() {
        var time = Int((roadmap.date?.timeIntervalSince(Date()) ?? 300) / (60 * 60 * 24))
        if time <= 0 {
            time = 0
        }
        let formatt = DateFormatter()
        formatt.timeStyle = .none
        formatt.dateStyle = .short
        currentCountDownView.title.text = roadmap.name
        currentCountDownView.date.text = formatt.string(from: roadmap.date ?? Date())
        currentCountDownView.timer.text = String(time)
    }
}
