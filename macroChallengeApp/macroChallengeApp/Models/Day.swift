//
//  Day.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct Day: Codable {
    var id: Int
    var date: String
    var activity: [Activity]
    var isSelected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case activity
    }

    init(isSelected: Bool, date: Date) {
        self.id = 1
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .short
        self.date = format.string(from: date)
        self.isSelected = isSelected
        self.activity = []
    }
}

extension Day: CustomStringConvertible {
    var description: String {
        return "{id: \(id), date: \(date)}"
    }
}
