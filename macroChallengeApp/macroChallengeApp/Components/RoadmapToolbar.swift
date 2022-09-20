//
//  RoadmapToolbar.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 15/09/22.
//

import UIKit

class RoadmapToolbar: UIToolbar {
    func initLayout(coordinator: NewRoadmapCoordinator) {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.barStyle = .default
        self.backgroundColor = .red
    }
    func setItems(viewController: UIViewController, funcNext: Selector, funcPrevious: Selector, nextText: String, previousText: String) -> [UIBarButtonItem] {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let previous = UIBarButtonItem(title: previousText, style: .plain, target: self, action: funcPrevious)
        let next = UIBarButtonItem(title: nextText, style: .plain, target: self, action: funcNext)
        let items = [spacer, previous, spacer, spacer, spacer, spacer, spacer, spacer, spacer, next, spacer]
        return items
    }
    
}
