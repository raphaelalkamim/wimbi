//
//  UserRoadmap.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 21/09/22.
//

import Foundation

struct UserRoadmap: Codable {
    var id: Int
    var roadmap: RoadmapDTO
    var role: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case roadmap
        case role
    }
}

extension UserRoadmap: CustomStringConvertible {
    var description: String {
        return "{id:\(id), roadmap:\(roadmap), role:\(role)}"
    }
}
