//
//  MyTripViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit

class MyTripViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let myTripView = MyTripView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupMyTripView()
        myTripView.bindCollectionView(delegate: self, dataSource: self)
        myTripView.bindTableView(delegate: self, dataSource: self)
    }
}
