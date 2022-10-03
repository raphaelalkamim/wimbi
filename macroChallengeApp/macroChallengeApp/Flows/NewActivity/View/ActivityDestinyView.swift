//
//  DestinyView.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 12/09/22.
//

import UIKit
import MapKit
import SnapKit

class ActivityDestinyView: UIView {
    var mapView: MKMapView
    var searchBar: UISearchBar
    var searchController: UISearchController? = nil
    var designSystem: DesignSystem = DefaultDesignSystem.shared
    override init(frame: CGRect) {
        self.mapView = MKMapView()
        self.searchBar = UISearchBar()
        self.searchController = UISearchController()
        
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        // view
        self.backgroundColor = designSystem.palette.backgroundPrimary
        
        // mapa
        self.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(designSystem.spacing.xLargePositive)
            make.trailing.equalToSuperview().offset(designSystem.spacing.xLargeNegative)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
        mapView.layer.cornerRadius = 16
        mapView.showsUserLocation = true
        
    }
    
    func addSearchBarNavigation(navigation: UINavigationItem) {
        navigation.searchController = searchController
        navigation.title = "Destiny"
        self.searchController?.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchController(locationTable: LocationSearchTableViewController) {
        // searchBar
        searchController = UISearchController(searchResultsController: locationTable)
        guard let searchController = searchController else {
            return
        }
        
        searchController.searchResultsUpdater = locationTable
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchBar = searchController.searchBar
        searchBar.placeholder = "Para onde você vai?"
        searchBar.sizeToFit()
    }
}
