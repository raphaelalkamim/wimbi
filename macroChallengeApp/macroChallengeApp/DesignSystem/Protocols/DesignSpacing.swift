//
//  DesignSpacing.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

protocol DesignSpacing {
    var xSmallPositive: CGFloat { get }
    var smallPositive: CGFloat { get }
    var mediumPositive: CGFloat { get }
    var largePositive: CGFloat { get }
    var xLargePositive: CGFloat { get }
    
    var xSmallNegative: CGFloat { get }
    var smallNegative: CGFloat { get }
    var mediumNegative: CGFloat { get }
    var largeNegative: CGFloat { get }
    var xLargeNegative: CGFloat { get }
}
