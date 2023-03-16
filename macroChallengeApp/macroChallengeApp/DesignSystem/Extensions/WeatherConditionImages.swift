//
//  WeatherConditionImages.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 15/03/23.
//

import UIKit

enum WeatherConditionImages {
    
    enum  VisibilityProperties {
        static let blowingDust : UIImage = UIImage(named: "weatherWind")!
        static let clear : UIImage = UIImage(named: "weatherSun")!
        static let cloudy : UIImage = UIImage(named: "weatherCloud")!
        static let foggy : UIImage = UIImage(named: "weatherCloud")!
        static let haze : UIImage = UIImage(named: "weatherCloudSun")!
        static let mostlyClear : UIImage = UIImage(named: "weatherSun")!
        static let mostlyCloudy : UIImage = UIImage(named: "weatherCloud")!
        static let partlyCloudy : UIImage = UIImage(named: "weatherCloudSun")!
        static let smoky : UIImage = UIImage(named: "weatherCloudWind")!
    }
    
    enum WindProperties {
        static let breezy : UIImage = UIImage(named: "weatherCloudWind")!
        static let windy : UIImage = UIImage(named: "weatherWind")!
    }
    
    enum PrecipitationProperties {
        static let drizzle : UIImage = UIImage(named: "weatherRain")!
        static let heavyRain : UIImage = UIImage(named: "weatherThunder")!
        static let isolatedThunderstorms : UIImage = UIImage(named: "weatherCloudThunder")!
        static let rain : UIImage = UIImage(named: "weatherRain")!
        static let sunShowers : UIImage = UIImage(named: "weatherRainSun")!
        static let scatteredThunderstorms : UIImage = UIImage(named: "weatherCloudThunder")!
        static let strongStorms : UIImage = UIImage(named: "weatherThunder")!
        static let thunderstorms : UIImage = UIImage(named: "weatherThunder")!
    }
    
    enum HazardousProperties {
        static let frigid : UIImage = UIImage(named: "weatherSun")!
        static let hail : UIImage = UIImage(named: "weatherSun")!
        static let hot : UIImage = UIImage(named: "weatherSun")!
    }
    
    enum WinterProperties {
        static let flurries : UIImage = UIImage(named: "weatherSnow")!
        static let sleet : UIImage = UIImage(named: "weatherSnow")!
        static let snow : UIImage = UIImage(named: "weatherSnow")!
        static let sunFlurries : UIImage = UIImage(named: "weatherSnow")!
        static let wintryMix : UIImage = UIImage(named: "weatherSnow")!
    }
    
    enum HazardousWinterProperties {
        static let blizzard : UIImage = UIImage(named: "weatherSnow")!
        static let blowingSnow : UIImage = UIImage(named: "weatherSnow")!
        static let freezingDrizzle : UIImage = UIImage(named: "weatherSnow")!
        static let freezingRain : UIImage = UIImage(named: "weatherSnow")!
        static let heavySnow : UIImage = UIImage(named: "weatherSnow")!
    }
    
    enum TropicalHazardProperties {
        static let hurricane : UIImage = UIImage(named: "weatherHurricane")!
        static let tropicalStorm : UIImage = UIImage(named: "weatherHurricane")!
    }
}

