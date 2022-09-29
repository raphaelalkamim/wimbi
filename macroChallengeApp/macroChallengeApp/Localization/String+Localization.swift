//
//  String+Localization.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 28/09/22.
//

import Foundation
import func Foundation.NSLocalizedString


extension String {
    func localized() -> String {
        return NSLocalizedString (
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
