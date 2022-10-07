//
//  Sequence.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 07/10/22.
//

import Foundation
import UIKit

extension Sequence {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}
