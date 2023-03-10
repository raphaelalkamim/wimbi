//
//  LocationSearchTableViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 12/09/22.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    var handleMapSearchDelegate: HandleMapSearch?
    let designSystem = DefaultDesignSystem.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DefaultCell")
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        let addressInformation: [String] = [selectedItem.thoroughfare ?? "", selectedItem.subThoroughfare ?? "", selectedItem.locality ?? "", selectedItem.subLocality ?? "", selectedItem.administrativeArea ?? "", selectedItem.country ?? ""]
        
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
        cell.detailTextLabel?.text = address
        
        cell.textLabel?.stylize(with: designSystem.text.body)
        cell.detailTextLabel?.stylize(with: designSystem.text.footnote)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
}
