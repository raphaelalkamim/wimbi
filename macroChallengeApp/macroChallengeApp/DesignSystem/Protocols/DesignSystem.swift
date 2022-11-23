//
//  DesignSystem.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

protocol DesignSystem {
    var palette: DesignPalette { get }
    var spacing: DesignSpacing { get }
    var text: DesignText { get }
    var images: DesignImages { get }
    var imagesActivities: DesignImagesActivities { get }
}
