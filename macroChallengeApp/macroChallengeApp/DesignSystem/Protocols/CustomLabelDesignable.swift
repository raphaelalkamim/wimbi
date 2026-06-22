//
//  CustomLabelDesignable.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 08/09/22.
//

import UIKit

protocol CustomLabelDesignable: TextStyle {
    @MainActor func custom(_ label: UILabel)
}
