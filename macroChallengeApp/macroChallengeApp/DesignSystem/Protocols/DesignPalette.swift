//
//  DesignPallet.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//
import UIKit

protocol DesignPalette {
    var backgroundPrimary: UIColor { get }
    var accent: UIColor { get }
    var textPrimary: UIColor { get }
    var titlePrimary: UIColor { get }
    var backgroundCell: UIColor { get }
    var caption: UIColor { get }
    
    var greenCamp: UIColor { get }
    var blueBeach: UIColor { get }
    var yellowMontain: UIColor { get }
    var redCity: UIColor { get }
}
