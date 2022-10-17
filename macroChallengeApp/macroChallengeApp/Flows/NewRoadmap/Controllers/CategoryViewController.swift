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
    [Category(title: "Countryside", subtitle: "A welcoming journey with more contact with nature.".localized(), icon: "categoryCamp"),
     Category(title: "Beach", subtitle: "A trip to enjoy and refresh yourself on a nice sunny day.".localized(), icon: "categoryBeach"),
     Category(title: "Mountain", subtitle: "A cozy trip, with cooler temperatures to enjoy the view.".localized(), icon: "categoryMountain"),
     Category(title: "City", subtitle: "An immersive journey into the habits of other cities or countries.".localized(), icon: "categoryCity")]
    
    var roadmap = Roadmaps()
    var editRoadmap = RoadmapLocal()
    var edit = false
    var nextButton = UIBarButtonItem()
    var categorySelected = ""
    
    weak var delegateRoadmap: MyTripViewController?

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
        if edit {
            setupEdition()
            coordinator?.startEditDestiny(roadmap: self.roadmap, editRoadmap: self.editRoadmap, delegate: delegateRoadmap!)
        } else {
            coordinator?.startDestiny(roadmap: self.roadmap)
        }
    }
    @objc func cancelRoadmap() {
        coordinator?.dismissRoadmap(isNewRoadmap: false)
    }
    
    func setupEdition() {
        roadmap.category = self.categorySelected
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

        if roadmap.category == "No category" && edit == false {
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
        cell.setCell(title: categories[indexPath.row].title.localized(), subtitle: categories[indexPath.row].subtitle, icon: categories[indexPath.row].icon)
        cell.backgroundColor = designSystem.palette.backgroundCell
        cell.layer.cornerRadius = 16
        
        if edit {
            if categories[indexPath.row].title == editRoadmap.category ?? "NoCategory" {
                self.categorySelected = categories[indexPath.row].title
                cell.selectedBackgroundView()
            }
        } 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.selectedBackgroundView()
            self.roadmap.category = categories[indexPath.row].title
            self.categorySelected = categories[indexPath.row].title
            nextButton.isEnabled = true
        }
        for index in 0..<categories.count where index != indexPath.row {
            if let cell = collectionView.cellForItem(at: [0, index]) as? CategoryViewCell {
                cell.notSelectedBackgroundView()
            }
        }
    }
}
