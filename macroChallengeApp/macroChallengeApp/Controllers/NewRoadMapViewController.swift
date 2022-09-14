//
//  NewRoadMapViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 12/09/22.
//

import Foundation
import UIKit
import SnapKit

class NewRoadMapViewController: UIViewController {
    let categoryView = CategoryView()
    let categories: [Category] =
    [Category(title: "Camp", subtitle: "Descrição aqui", icon: "categoryCamp"),
     Category(title: "Beach", subtitle: "Descrição aqui", icon: "categoryBeach"),
     Category(title: "Mountain", subtitle: "Descrição aqui", icon: "categoryMountain"),
     Category(title: "City", subtitle: "Descrição aqui", icon: "categoryCity")]
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // category
        categoryView.bindColletionView(delegate: self, dataSource: self)
        setupCategoryView()
    }
}
