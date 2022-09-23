//
//  DefaultDesignSystem.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

struct DefaultDesignSystem: DesignSystem {
    static var shared: DesignSystem = DefaultDesignSystem()
    let text = DesignText()
    let palette: DesignPalette = DefaultDesignPalette()
    let spacing: DesignSpacing = DefaultDesignSpacing()
    let images: DesignImages = DefaultDesignSystemImages()
    let imagesDefault: DesignDefaultImages = DefaultDesignDefaultSystemImages()
    let imagesActivities: DesignImagesActivities = DefaultDesignActivitiesImages()
}
