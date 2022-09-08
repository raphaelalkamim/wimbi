//
//  TextStyle.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

protocol TextStyle {
    var font: UIFont { get }
    var color: UIColor { get }
    var alignment: NSTextAlignment { get }
}
