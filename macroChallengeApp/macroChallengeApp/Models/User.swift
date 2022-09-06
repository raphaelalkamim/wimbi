//
//  Users.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct User: Codable {
    
    var id: Int
    var date: String
    var roadmaps: Roadmaps
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "dd/mm/yyyy"
        case roadmaps
    }
    
}

extension User: CustomStringConvertible {
    var description: String {
        return "{id:\(id),date:\(date),roadmaps\(roadmaps)}"
    }
}
