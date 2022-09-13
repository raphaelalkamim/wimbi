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
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
    }
}

extension Day: CustomStringConvertible {
    var description: String {
        return "{id: \(id), date: \(date)}"
    }
}
