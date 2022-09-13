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
    private let categoryView = CategoryView()
    private let categories: [Category] =
    [Category(title: "Camp", subtitle: "Descrição aqui", icon: "categoryCamp"),
     Category(title: "Beach", subtitle: "Descrição aqui", icon: "categoryBeach"),
     Category(title: "Mountain", subtitle: "Descrição aqui", icon: "categoryMountain"),
     Category(title: "City", subtitle: "Descrição aqui", icon: "categoryCity")]
    
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.bindColletionView(delegate: self, dataSource: self)
        setup()
    }
}

extension NewRoadMapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}

extension NewRoadMapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as? CategoryViewCell else {
            preconditionFailure("Cell not find")
        }
        cell.setup()
        cell.setCell(title: categories[indexPath.row].title, subtitle: categories[indexPath.row].subtitle, icon: categories[indexPath.row].icon)
        cell.backgroundColor = designSystem.palette.backgroundCell
        cell.layer.cornerRadius = 16
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.selectedBackgroundView()
            print(cell.title.text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.notSelectedBackgroundView()
        }
    }
}

extension NewRoadMapViewController {
    func setup() {
        self.view.addSubview(categoryView)
        setupConstraints()
    }
    
    func setupConstraints() {
        categoryView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
