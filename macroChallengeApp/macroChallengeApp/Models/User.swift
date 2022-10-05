//
//  Users.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation

struct User: Codable {
    var id: Int
    var usernameApp: String
    var name: String
    var photoId: String
    var currencyType: String
    var userRoadmap: [UserRoadmap]
    
    enum CodingKeys: String, CodingKey {
        case id
        case usernameApp
        case name
        case photoId
        case userRoadmap
        case currencyType
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return "{id:\(id), usernameApp:\(usernameApp), name:\(name), photoId:\(photoId), currencyType:\(currencyType), userRoadmaps:\(userRoadmap)}"
    }
}
