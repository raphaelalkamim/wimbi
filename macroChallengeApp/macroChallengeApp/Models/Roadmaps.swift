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
    }
}

extension Roadmaps: CustomStringConvertible {
    var description: String {
        return "{id: \(id), roadmapName: \(name), location: \(location)}"
    }
}
