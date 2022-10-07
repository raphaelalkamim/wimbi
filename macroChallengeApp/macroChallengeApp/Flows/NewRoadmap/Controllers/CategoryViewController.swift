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
    [Category(title: "Countryside".localized(), subtitle: "A welcoming journey with more contact with nature.".localized(), icon: "categoryCamp"),
     Category(title: "Beach".localized(), subtitle: "A trip to enjoy and refresh yourself on a nice sunny day.".localized(), icon: "categoryBeach"),
     Category(title: "Mountain".localized(), subtitle: "A cozy trip, with cooler temperatures to enjoy the view.".localized(), icon: "categoryMountain"),
     Category(title: "City".localized(), subtitle: "An immersive journey into the habits of other cities or countries.".localized(), icon: "categoryCity")]
    
    var roadmap = Roadmaps()
    var nextButton = UIBarButtonItem()

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
        coordinator?.startDestiny(roadmap: roadmap)
    }
    @objc func cancelRoadmap() {
        coordinator?.dismissRoadmap(isNewRoadmap: false)
    }
    
    func setupToolbar() {
        let barItems = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelRoadmap))
        barItems.tintColor = .accent
        self.navigationItem.leftBarButtonItems = [barItems]
        
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = true
        toolBar.barStyle = .default
        toolBar.backgroundColor = designSystem.palette.backgroundCell
        
        nextButton = UIBarButtonItem(title: "Next".localized(), style: .plain, target: self, action: #selector(nextPage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [spacer, spacer, spacer, spacer, spacer, spacer, spacer, spacer, spacer, spacer, spacer, nextButton, spacer]
        self.setToolbarItems(items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = false
        
        if roadmap.category == "No category" {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
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
            roadmap.category = cell.title.text ?? "Nova Categoria"
            nextButton.isEnabled = true
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.notSelectedBackgroundView()
        }
    }
}
