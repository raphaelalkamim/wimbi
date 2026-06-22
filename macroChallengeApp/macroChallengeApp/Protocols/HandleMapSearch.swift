//
//  HandleMapSearch.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 12/09/22.
//

import Foundation
import MapKit

@MainActor
protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}
