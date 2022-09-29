//
//  DestinyViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 15/09/22.
//

import UIKit
import SnapKit
import CoreLocation
import MapKit

class DestinyViewController: UIViewController {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    weak var coordinator: NewRoadmapCoordinator?

    let destinyView = DestinyView(frame: .zero)
    let locationManager = CLLocationManager()
    let locationSearchTable = LocationSearchTableViewController()
    var searchedText: String = ""
    var subtitle: String = ""
    var selectedPin: MKPlacemark? = nil
    var placeTitle = ""
    var placeCoords = ""
    var roadmap: Roadmaps
    
    init(roadmap: Roadmaps) {
        self.roadmap = roadmap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDestinyView()
        self.setupToolbar()
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

    func createPin(title: String, coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = title
        
        return pin
    }
    
    func setupToolbar() {
        let barItems = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelRoadmap))
        barItems.tintColor = .accent
        self.navigationItem.leftBarButtonItems = [barItems]
        
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = true
        toolBar.barStyle = .default
        toolBar.backgroundColor = designSystem.palette.backgroundCell
        
        let previous = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(backPage))
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [spacer, previous, spacer, spacer, spacer, spacer, spacer, spacer, spacer, next, spacer]
        self.setToolbarItems(items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc func nextPage() {
        self.roadmap.name = placeTitle
        self.roadmap.location = placeCoords
        coordinator?.startDays(roadmap: roadmap)
    }
    @objc func backPage() {
        coordinator?.back()
    }
    @objc func cancelRoadmap() {
        coordinator?.dismissRoadmap(isNewRoadmap: false)
    }
}

extension DestinyViewController: UISearchBarDelegate {
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

extension DestinyViewController: CLLocationManagerDelegate {
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

extension DestinyViewController: MKMapViewDelegate {
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

extension DestinyViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        
        destinyView.mapView.removeAnnotations(destinyView.mapView.annotations)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = placemark.coordinate
        placeCoords = "\(placemark.coordinate.latitude) \(placemark.coordinate.longitude)"

        if let name = placemark.name {
            annotation.title = name
            placeTitle = name
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
