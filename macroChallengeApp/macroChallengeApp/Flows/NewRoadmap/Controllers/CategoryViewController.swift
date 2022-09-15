//
//  CategoryViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 15/09/22.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    weak var coordinator: NewRoadmapCoordinator?

    let categoryView = CategoryView()
    let categories: [Category] =
    [Category(title: "Camp", subtitle: "Descrição aqui", icon: "categoryCamp"),
     Category(title: "Beach", subtitle: "Descrição aqui", icon: "categoryBeach"),
     Category(title: "Mountain", subtitle: "Descrição aqui", icon: "categoryMountain"),
     Category(title: "City", subtitle: "Descrição aqui", icon: "categoryCity")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.bindColletionView(delegate: self, dataSource: self)
        setupCategoryView()
    }
    func setupCategoryView() {
        self.tabBarController?.removeFromParent()
        self.view.backgroundColor = .backgroundPrimary
        self.view.addSubview(categoryView)
        
        setupConstraints()
        setupToolbar()
    }
    
    func setupConstraints() {
        categoryView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    @objc func nextPage() {
        coordinator?.startDestiny()
    }
    @objc func cancelRoadmap() {
        coordinator?.dismiss()
    }
    
    func setupToolbar() {
        let barItems = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelRoadmap))
        barItems.tintColor = .systemRed
        self.navigationItem.leftBarButtonItems = [barItems]
        
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = true
        toolBar.barStyle = .default
        toolBar.backgroundColor = designSystem.palette.backgroundCell
        
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [spacer, spacer, spacer, spacer, spacer, spacer, spacer, next, spacer]
        self.setToolbarItems(items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}

extension CategoryViewController: UICollectionViewDataSource {
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
