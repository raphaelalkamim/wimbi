//
//  String+Localization.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 28/09/22.
//

import func Foundation.NSLocalizedString

// swiftlint:disable nslocalizedstring_key
extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
// swiftlint:enable nslocalizedstring_key
