//
//  Like.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct Like: Codable {
    
    var id: Int
    var roadmap: Roadmaps
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case roadmap
        case user
    }
}

extension Like: CustomStringConvertible {
    var description: String {
        return "id: \(id), roadmap: \(roadmap), user: \(user)"
    }
}
