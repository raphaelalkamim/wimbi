//
//  Users.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct User: Codable {
    var id: Int
    var roadmaps: Roadmaps
    
    enum CodingKeys: String, CodingKey {
        case id
        case roadmaps
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return "{id:\(id),roadmaps\(roadmaps)}"
    }
}
