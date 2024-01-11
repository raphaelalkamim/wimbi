//
//  String.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 11/01/24.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.date(from: self) ?? Date()
    }
}
