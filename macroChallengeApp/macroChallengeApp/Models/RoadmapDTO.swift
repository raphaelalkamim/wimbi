//
//  RoadmapDTO.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 21/09/22.
//

import Foundation

struct RoadmapDTO: Codable {
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
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case budget
        case dayCount
        case peopleCount
        case imageId
        case category
        case dateInitial
        case dateFinal
    }

}

extension RoadmapDTO: CustomStringConvertible {
    var description: String {
        return "{id: \(id), roadmapName: \(name), location: \(location)}"
    }
}
