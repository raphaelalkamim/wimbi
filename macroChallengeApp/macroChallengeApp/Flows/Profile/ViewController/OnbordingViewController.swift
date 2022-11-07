//
//  OnbordingViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 01/11/22.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    weak var coordinatorExplore: ExploreCoordinator?

    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let onboardingView = OnboardingView()
    weak var delegate: SignOutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOnboardingView()
        onboardingView.exploreButton.addTarget(self, action: #selector(explore), for: .touchUpInside)
        onboardingView.okButton.addTarget(self, action: #selector(ok), for: .touchUpInside)
    }
    
    @objc func explore() {
        UIAccessibility.post(notification: .screenChanged, argument: coordinator?.navigationController)
        coordinator?.startExplore()
        coordinatorExplore?.dismiss()
        UserDefaults.standard.set(true, forKey: "onboard")
    }
    
    @objc func ok() {
        coordinator?.dismiss()
        coordinatorExplore?.dismiss()
        UserDefaults.standard.set(true, forKey: "onboard")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "onboard")

    }
}

extension OnboardingViewController {
    func setupOnboardingView() {
        view.addSubview(onboardingView)
        setupConstraints()
    }
    func setupConstraints() {
        onboardingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
