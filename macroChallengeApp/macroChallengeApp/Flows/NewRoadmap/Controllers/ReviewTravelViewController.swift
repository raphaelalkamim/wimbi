//
//  ReviewTravelViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 16/09/22.
//

import UIKit

class ReviewTravelViewController: UIViewController {
    weak var coordinator: NewRoadmapCoordinator?

    let reviewTravelView = ReviewTravelView()
    let designSystem = DefaultDesignSystem.shared
    var dataManager = DataManager.shared
    
    var roadmap: Roadmaps
    
    init(roadmap: Roadmaps) {
        self.roadmap = roadmap
        super.init(nibName: nil, bundle: nil)
        self.setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupReviewTravelView()
        self.setupToolbar()
    }
    
    func setupReviewTravelView() {
        navigationItem.title = "Minha Viagem"
        self.view.addSubview(reviewTravelView)
        setupReviewConstraints()
        reviewTravelView.bindTableView(delegate: self, dataSource: self)
    }
    
    func setupReviewConstraints() {
        reviewTravelView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupToolbar() {
        let barItems = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelRoadmap))
        self.navigationItem.leftBarButtonItems = [barItems]
        
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = true
        toolBar.barStyle = .default
        toolBar.backgroundColor = designSystem.palette.backgroundCell
        
        let previous = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(backPage))
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [spacer, previous, spacer, spacer, spacer, spacer, spacer, spacer, spacer, next, spacer]
        self.setToolbarItems(items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    @objc func nextPage() {
        dataManager.postRoadmap(roadmap: roadmap)
        // save in Core Data
        let newRoadmap = RoadmapRepository.shared.createRoadmap(roadmap: self.roadmap)
        RoadmapRepository.shared.saveContext()
        print(newRoadmap)
        
        coordinator?.dismiss()
    }
    @objc func backPage() {
        coordinator?.back()
    }
    @objc func cancelRoadmap() {
        coordinator?.dismiss()
    }
    func setupContent() {
        self.reviewTravelView.subtitle.text = self.roadmap.category
        self.reviewTravelView.title.text = self.roadmap.name
        
        self.setupCategory()
    }
    func setupCategory() {
        if self.roadmap.category == "Beach" {
            self.reviewTravelView.categoryImage.image = designSystem.images.beach
        } else if self.roadmap.category == "Mountain" {
            self.reviewTravelView.categoryImage.image = designSystem.images.mountain
        } else if self.roadmap.category == "City" {
            self.reviewTravelView.categoryImage.image = designSystem.images.city
        } else {
            self.reviewTravelView.categoryImage.image = designSystem.images.camp
        }
    }
}

extension ReviewTravelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ReviewTravelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reviewTravelView.daysTable {
            return 3
        } else if tableView == reviewTravelView.travelersTable {
            return 1
        } else if tableView == reviewTravelView.privacyTitle {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let format = DateFormatter()
        format.timeStyle = .none
        format.dateStyle = .medium
        
        if tableView == reviewTravelView.daysTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                if indexPath.row == 0 {
                    newCell.configureDays(indexPath: 0, value: String(self.roadmap.dayCount))
                    cell = newCell
                }
                if indexPath.row == 1 {
                    newCell.configureDays(indexPath: 1, value: format.string(from: self.roadmap.dateInitial))
                    cell = newCell
                }
                if indexPath.row == 2 {
                    newCell.configureDays(indexPath: 2, value: format.string(from: self.roadmap.dateFinal))
                    cell = newCell
                }
            }
        }
        if tableView == reviewTravelView.travelersTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTravelers(daysValue: self.roadmap.peopleCount)
                cell = newCell
            }
        }
        if tableView == reviewTravelView.privacyTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTripStatus(isPublic: self.roadmap.isPublic)
                cell = newCell
            }
        }
        return cell
    }
}
