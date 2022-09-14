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
    let destinyView = DestinyView()
    let locationManager = CLLocationManager()
    let locationSearchTable = LocationSearchTableViewController()
    var categoria: String = ""
    var selectedPin: MKPlacemark? = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDestinyView()
        self.tabBarController?.removeFromParent()
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = true
        toolBar.barStyle = .default
        toolBar.backgroundColor = .red
        let previous = UIBarButtonItem(title: "Anterior", style: .plain, target: self, action: #selector(clicou))
        let next = UIBarButtonItem(title: "Próximo", style: .plain, target: self, action: #selector(clicou))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [spacer, previous, spacer, spacer, spacer, spacer, spacer, spacer, spacer, next, spacer]
        self.setToolbarItems(items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
      
    }
    @objc func clicou() {
        print("clicou")
    }
}
