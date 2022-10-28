//
//  Tag.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 27/10/22.
//

import Foundation

struct Tag: Codable {
    var id: Int
    var name: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
}
