//
//  LocationNewActivityViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 21/09/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class LocationNewActivityViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let destinyView = ActivityDestinyView(frame: .zero)
    let locationManager = CLLocationManager()
    let locationSearchTable = LocationSearchTableViewController()
    var searchedText: String = ""
    var subtitle: String = ""
    var selectedPin: MKPlacemark? = nil
    weak var delegate: ChangeTextTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDestinyView()
    }
    
    func createPin(title: String, coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = title
        
        return pin
    }
    
    func setupDestinyView() {
        view.addSubview(destinyView)
        
        destinyView.setupSearchController(locationTable: locationSearchTable)
        
        destinyView.mapView.delegate = self
        destinyView.searchBar.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        destinyView.addSearchBarNavigation(navigation: navigationItem)
        destinyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        definesPresentationContext = true
        
        locationSearchTable.mapView = destinyView.mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
}

extension LocationNewActivityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchedText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        destinyView.mapView.removeAnnotations(destinyView.mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchedText
        request.region = destinyView.mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { response, _ in
            guard let response = response else {
                return
            }
            
            for item in response.mapItems {
                if let name = item.name, let location = item.placemark.location {
                    let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    let pin = self.createPin(title: name, coordinate: coordinate)
                    self.destinyView.mapView.addAnnotation(pin)
                }
            }
        })
        
        searchBar.resignFirstResponder()
        destinyView.searchController?.isActive = false
    }
}

extension LocationNewActivityViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            destinyView.mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension LocationNewActivityViewController: MKMapViewDelegate {
    // change view of mkpoint
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title as Any)
    }
}

extension LocationNewActivityViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        
        destinyView.mapView.removeAnnotations(destinyView.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        let placeCoords = "\(placemark.coordinate.latitude) \(placemark.coordinate.longitude)"
        
        let addressInformation: [String] = [placemark.thoroughfare ?? "", placemark.subThoroughfare ?? "", placemark.locality ?? "", placemark.subLocality ?? "", placemark.administrativeArea ?? "", placemark.country ?? ""]
        
        var address = ""
        for index in 0..<addressInformation.count {
            if !addressInformation[index].isEmpty {
                if index == addressInformation.count - 1 {
                    address += "\(addressInformation[index])"
                } else {
                    address += "\(addressInformation[index]), "
                }
            }
        }
        
        if let name = placemark.name {
            annotation.title = name
            delegate?.changeText(coords: placeCoords, locationName: name, address: address)
        }
        if let city = placemark.locality, let state = placemark.administrativeArea {
            subtitle = "\(city) \(state)"
            annotation.subtitle = subtitle
        }
        destinyView.mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        destinyView.mapView.setRegion(region, animated: true)
    }
}
