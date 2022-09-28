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
    var peopleCount: Int
    var imageId: String
    var category: String
    var isShared: Bool
    var isPublic: Bool
    var shareKey: String
    var days: [Day]
    var createdAt = Date()
    
    var dateInitial: Date
    var dateFinal: Date
    
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
        case days
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
        self.days = [Day()]
        self.dateFinal = Date()
        self.dateInitial = Date()
    }
}

extension Roadmaps: CustomStringConvertible {
    var description: String {
        return "{id: \(id), roadmapName: \(name), location: \(location)}"
    }
}
