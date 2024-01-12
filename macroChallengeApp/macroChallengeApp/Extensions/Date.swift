//
//  Date.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 12/01/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        return dateFormatter.string(from: self)
    }
}
