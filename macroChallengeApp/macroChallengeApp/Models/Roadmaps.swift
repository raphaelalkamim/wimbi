//
//  Roadmaps.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct Roadmap: Codable {
    var id: Int
    var name: String
    var location: String
    var budget: Double
    var dayCount: Int
    var dateInitial: String
    var dateFinal: String
    var peopleCount: Int
    var imageId: String
    var category: String
    var currency: String
    var likesCount: Int

    // we need to add to BE
    var isShared: Bool
    var shareKey: String
    var isPublic: Bool
    var createdAt = Date()

    var days: [Day]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case budget
        case dayCount
        case peopleCount
        case imageId
        case category
        case isShared
        case isPublic
        case shareKey
        case currency
        case days = "day"
        case dateInitial
        case dateFinal
        case likesCount
    }
    init() {
        self.id = 1
        self.name = "New Itinerary"
        self.location = "LocationName"
        self.budget = 0
        self.dayCount = 1
        self.peopleCount = 1
        self.imageId = "defaultCover"
        self.category = "No category"
        self.isShared = false
        self.isPublic = false
        self.shareKey = "12345"
        self.days = [Day(isSelected: false, date: Date())]
        self.dateFinal = ""
        self.dateInitial = ""
        self.currency = "R$"
        self.likesCount = 0
    }
}

extension Roadmap: CustomStringConvertible {
    var description: String {
        return "{id: \(id), roadmapName: \(name), location: \(location)}"
    }
}
