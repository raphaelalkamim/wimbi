//
//  NetworkMonitor.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 19/10/22.
//

import Foundation
import UIKit
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var contected = false
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                self?.contected = true
            } else {
                self?.contected = false
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
