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
    var currency: String
    var address: String
    var link: String
    var day: Day?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tips
        case category
        case location
        case hour
        case budget
        case currency
        case address
        case link
        case day
    }
    
    init() {
        self.id = 0
        self.name = "New Activity"
        self.tips = ""
        self.category = "food"
        self.location = ""
        self.hour = ""
        self.budget = 0.00
        self.currency = "R$"
        self.address = ""
        self.link = ""
        self.day = Day(isSelected: true, date: Date())
    }
}

extension Activity: CustomStringConvertible {
    var description: String {
        return "id: \(id),name: \(name),category: \(category),location: \(location), hour: \(hour), budget: \(budget), currencyType: \(currency), Day: \(String(describing: day)), Tips: \(tips)"
    }
}
