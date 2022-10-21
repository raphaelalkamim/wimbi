//
//  Activity.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct Activity: Codable {    
    var id: Int
    var name: String
    var tips: String
    var category: String
    var location: String
    var hour: String
    var budget: Double
    var day: Day?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tips
        case category
        case location
        case hour
        case budget
    }
}

extension Activity: CustomStringConvertible {
    var description: String {
        return "id: \(id),name: \(name),category: \(category),location: \(location), hour: \(hour), hour: \(hour), budget: \(budget), Day: \(day)"
    }
}
