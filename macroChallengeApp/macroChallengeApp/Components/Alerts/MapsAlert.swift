//
//  AlertModel.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 09/12/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class AlertMapsModel: UIAlertController {
    init(location: String, controller: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        let coordsSeparated = location.split(separator: " ")
        
        let latitude = String(coordsSeparated[0])
        let longitude = String(coordsSeparated[1])
        
        let googleURL = "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"
        
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        let googleItem = ("Google Maps", URL(string: googleURL)!)
        let wazeItem = ("Waze", URL(string: wazeURL)!)
        var installedNavigationApps: [(String, URL)] = []
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.view.tintColor = .accent
        
        let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 16)]
        let string = NSAttributedString(string: "Which app would you like to use to access the address?".localized(), attributes: titleAtt as [NSAttributedString.Key: Any])
        
        alert.setValue(string, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Open on Maps".localized(), style: .default, handler: { _ in
            let coords = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude) ?? 0, longitude: CLLocationDegrees(longitude) ?? 0)
            let placemark = MKPlacemark(coordinate: coords)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Target Location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }))
        
        for app in installedNavigationApps {
            let title = "Open on".localized()
            let button = UIAlertAction(title: "\(title) \(app.0)", style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(_: UIAlertAction!) in
        }))
        controller.present(alert, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
