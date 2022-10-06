//
//  Roadmaps.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct Roadmaps: Codable {
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
    var isShared: Bool
    var isPublic: Bool
    var shareKey: String
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
        case days = "day"
        case dateInitial
        case dateFinal
    }
    init() {
        self.id = 1
        self.name = "New Roadmap"
        self.location = "LocationName"
        self.budget = 0
        self.dayCount = 1
        self.peopleCount = 1
        self.imageId = "ImageDefault"
        self.category = "No category"
        self.isShared = false
        self.isPublic = false
        self.shareKey = "12345"
        self.days = [Day(isSelected: false, date: Date())]
        self.dateFinal = ""
        self.dateInitial = ""
    }
}

extension Roadmaps: CustomStringConvertible {
    var description: String {
        return "{id: \(id), roadmapName: \(name), location: \(location)}"
    }
}
