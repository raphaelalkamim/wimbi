//
//  NewRoadmapViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 12/09/22.
//

import UIKit
import SnapKit
import CoreLocation
import MapKit

class NewRoadmapViewController: UIViewController {
    let destinyView = DestinyView(frame: .zero)
    let daysView = DaysView(frame: .zero)
    let locationManager = CLLocationManager()
    let locationSearchTable = LocationSearchTableViewController()
    var categoria: String = ""
    var selectedPin: MKPlacemark? = nil
    let designSystem = DefaultDesignSystem.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupDestinyView()
    
    }
}
