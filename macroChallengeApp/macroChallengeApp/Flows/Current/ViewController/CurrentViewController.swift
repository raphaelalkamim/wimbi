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
    var mostRecentRoadmaps: [RoadmapLocal] = []
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roadmaps = RoadmapRepository.shared.getRoadmap()
        if !roadmaps.isEmpty {
            roadmaps.sort {
                $0.date ?? Date() < $1.date ?? Date()
            }
            for newRoadmap in roadmaps {
                if newRoadmap.dateFinal ?? Date() > Date() { mostRecentRoadmaps.append(newRoadmap) }
            }
        }
        setup()
    }
}

extension CurrentViewController {
    func setup() {
        if !mostRecentRoadmaps.isEmpty {
            roadmap = mostRecentRoadmaps[0]
            currentEmptyView.removeFromSuperview()
            setupCountDownView()
            configCountDown()
        } else {
            // passa o timer para o widget
            UserDefaultsManager.shared.nextTrip = ""
            UserDefaultsManager.shared.countdown = ""
            setupEmptyView()
            currentCountDownView.removeFromSuperview()
        }
    }
    
    func setupCountDownView() {
        self.view.addSubview(currentCountDownView)
        currentCountDownView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.title = "Current Itinerary".localized()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        UINavigationBar.appearance().barTintColor = designSystem.palette.backgroundPrimary
        UINavigationBar.appearance().barStyle = .default
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline]
    }
    
    func setupEmptyView() {
        self.view.addSubview(currentEmptyView)
        currentEmptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.title = "Current Itinerary".localized()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        UINavigationBar.appearance().barTintColor = designSystem.palette.backgroundPrimary
        UINavigationBar.appearance().barStyle = .default
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline]
    }
    
    func configCountDown() {
        var time = Double((roadmap.date?.timeIntervalSince(Date()) ?? 300) / (60 * 60 * 24))
        if ceil(time) <= 1 {
            time = 0
            currentCountDownView.timer.text = "Your trip is \ntomorrow!".localized()
            currentCountDownView.timer.stylize(with: designSystem.text.xLargeTitle)
            currentCountDownView.timer.numberOfLines = 2
            currentCountDownView.timerType.isHidden = true
            currentCountDownView.subtitle.isHidden = true
            
        } else {
            currentCountDownView.timer.text = String(Int(ceil(time)))
            currentCountDownView.timer.stylize(with: designSystem.text.xxLargeTitle)
            currentCountDownView.timerType.isHidden = false
            currentCountDownView.subtitle.isHidden = false
        }
        let formatt = DateFormatter()
        formatt.timeStyle = .none
        formatt.dateStyle = .short
        formatt.dateFormat = "dd/MM/yyyy"
        currentCountDownView.title.text = roadmap.name
        currentCountDownView.date.text = formatt.string(from: roadmap.date ?? Date())
        
        // passa o timer para o widget
        UserDefaultsManager.shared.nextTrip = roadmap.name
        UserDefaultsManager.shared.countdown = String(Int(ceil(time)))
    }
}
