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
    let roadmapView = NewRoadmapView(frame: .zero)
    
    let locationManager = CLLocationManager()
    let locationSearchTable = LocationSearchTableViewController()
    var categoria: String = ""
    var selectedPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupRoadmapView()
    
    }
}

extension NewRoadmapViewController {
    func setupRoadmapView() {
        view.addSubview(roadmapView)
        
        roadmapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        definesPresentationContext = true
    }
}
