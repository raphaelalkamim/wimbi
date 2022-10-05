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
    var category: String
    var location: String
    var hour: String
    var budget: Double
    var currencyType: String
    var day: Day
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case location
        case hour
        case budget
        case currencyType
        case day
    }
}

extension Activity: CustomStringConvertible {
    var description: String {
        return "id: \(id),name: \(name),category: \(category),location: \(location), hour: \(hour), budget: \(budget), currencyType: \(currencyType), Day: \(day)"
    }
}
