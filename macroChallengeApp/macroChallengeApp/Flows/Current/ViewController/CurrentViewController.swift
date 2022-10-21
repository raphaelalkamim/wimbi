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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roadmaps = RoadmapRepository.shared.getRoadmap()
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
            currentEmptyView.removeFromSuperview()
        } else {
            setupEmptyView()
            currentCountDownView.removeFromSuperview()
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
            currentCountDownView.timer.text = "Your trip is \ntomorrow!".localized()
            currentCountDownView.timer.font = UIFont(name: "Avenir-Black", size: 40)
            currentCountDownView.timer.numberOfLines = 2
            currentCountDownView.timerType.isHidden = true
            currentCountDownView.subtitle.isHidden = true
        } else {
            currentCountDownView.timer.text = String(time)
            if time == 1 {
                currentCountDownView.subtitle.text = "Falta".localized()
                currentCountDownView.timerType.text = "day left".localized()
            }
        }
        let formatt = DateFormatter()
        formatt.timeStyle = .none
        formatt.dateStyle = .short
        formatt.dateFormat = "dd/MM/yyyy"
        currentCountDownView.title.text = roadmap.name
        currentCountDownView.date.text = formatt.string(from: roadmap.date ?? Date())
    }
}
