//
//  Currency.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 06/10/22.
//

import Foundation

struct RefreshToken: Decodable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    var refreshToken: String
    var idToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
    }
}
