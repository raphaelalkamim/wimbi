//
//  StringProtocol.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 29/09/22.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
