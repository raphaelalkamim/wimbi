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
    var category = ""
    var location = ""
    var daysCount = 1
    var start = Date()
    var final = Date()
    var peopleCount = 1
    var isPublic = false
    
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
        navigationItem.title = "My trip".localized()
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
        
        let previous = UIBarButtonItem(title: "Previous".localized(), style: .plain, target: self, action: #selector(backPage))
        let next = UIBarButtonItem(title: "Next".localized(), style: .plain, target: self, action: #selector(nextPage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let items = [spacer, previous, spacer, spacer, spacer, spacer, spacer, spacer, spacer, next, spacer]
        self.setToolbarItems(items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    @objc func nextPage() {
        roadmap.imageId = "beach0"
        
        // save in Backend
        dataManager.postRoadmap(roadmap: roadmap)
        
        // save in Core Data
        let newRoadmap = RoadmapRepository.shared.createRoadmap(roadmap: self.roadmap)
        RoadmapRepository.shared.saveContext()
        
        // save days in Roadmap
        var isFirstDay = false
        for index in 0..<roadmap.dayCount {
            if index == 0 {
                isFirstDay = true
            } else {
                isFirstDay = false
            }
            
            let dateFormat = DateFormatter()
            let date = dateFormat.date(from: roadmap.dateInitial)
            
            let newDay = DayRepository.shared.createDay(roadmap: newRoadmap, day: setupDays(startDay: date ?? Date(),
                                                                                            indexPath: index,
                                                                                            isSelected: isFirstDay))
            print(newDay)
        }
        
        UIAccessibility.post(notification: .screenChanged, argument: coordinator?.navigationController)
        coordinator?.dismiss(isNewRoadmap: true)
    }
    
    func setupDays(startDay: Date, indexPath: Int, isSelected: Bool) -> Day {
        let date = startDay.addingTimeInterval(Double(indexPath) * 24 * 3600)
        var day = Day(isSelected: isSelected, date: date)
        day.id = indexPath
        return day
    }
    @objc func backPage() {
        coordinator?.back()
    }
    @objc func cancelRoadmap() {
        coordinator?.dismissRoadmap(isNewRoadmap: false)
    }
    func setupContent() {
        self.daysCount = roadmap.dayCount
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "d/M/y"
        let date = dateFormat.date(from: roadmap.dateInitial)
        let dateFinal = dateFormat.date(from: roadmap.dateFinal)

        self.start = date ?? Date()
        self.final = dateFinal ?? Date()
        
        self.isPublic = roadmap.isPublic
        self.peopleCount = roadmap.peopleCount
        self.reviewTravelView.subtitle.text = self.roadmap.category
        self.reviewTravelView.title.text = self.roadmap.name
        self.reviewTravelView.setupCategory(category: roadmap.category)
        self.reviewTravelView.setupImage(category: roadmap.category)
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
                    newCell.configureDays(indexPath: 0, value: String(self.daysCount))
                    cell = newCell
                }
                if indexPath.row == 1 {
                    newCell.configureDays(indexPath: 1, value: format.string(from: self.start))
                    cell = newCell
                }
                if indexPath.row == 2 {
                    newCell.configureDays(indexPath: 2, value: format.string(from: self.final))
                    cell = newCell
                }
            }
        }
        if tableView == reviewTravelView.travelersTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTravelers(daysValue: self.peopleCount)
                cell = newCell
            }
        }
        if tableView == reviewTravelView.privacyTable {
            if let newCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell {
                newCell.configureTripStatus(isPublic: self.isPublic)
                cell = newCell
            }
        }
        return cell
    }
}
