//
//  DaysViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 15/09/22.
//

import UIKit

class DaysViewController: UIViewController {
    let designSystem = DefaultDesignSystem.shared
    let daysView = DaysView(frame: .zero)
    weak var coordinator: NewRoadmapCoordinator?

    var roadmap: Roadmaps
    var initialDate = UIDatePicker()
    var finalDate = UIDatePicker()
    var travelersCount = UIPickerView()
    
    var editRoadmap = RoadmapLocal()
    var edit = false
    
    weak var delegateRoadmap:  MyTripViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDaysView()
        self.setupToolbar()
    }
    init(roadmap: Roadmaps) {
        self.roadmap = roadmap
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupToolbar() {
        let barItems = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelRoadmap))
        barItems.tintColor = .accent
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
        self.setupEdition()
        if edit {
            coordinator?.startEditReview(roadmap: self.roadmap, editRoadmap: self.editRoadmap, delegate: delegateRoadmap!)
        } else {
            coordinator?.startReview(roadmap: self.roadmap)
        }
    }
    
    @objc func backPage() {
        coordinator?.back()
    }
    
    @objc func cancelRoadmap() {
        coordinator?.dismissRoadmap(isNewRoadmap: false)
    }
    
    func countDays(datePickerInitial: UIDatePicker, datePickerFinal: UIDatePicker) -> Double {
        let initialDate = datePickerInitial.date
        let finalDate = datePickerFinal.date
        return ( finalDate.timeIntervalSince(initialDate) / (60 * 60 * 24) ) + 1
    }
    
    func setupEdition() {
        self.roadmap.dateFinal = finalDate.date
        self.roadmap.dateInitial = initialDate.date
        self.roadmap.dayCount = Int(self.countDays(datePickerInitial: self.initialDate, datePickerFinal: self.finalDate))
        self.roadmap.peopleCount = (self.travelersCount.selectedRow(inComponent: 0)) + 1
        self.roadmap.isPublic = daysView.isPublic
    }
}

extension DaysViewController: UITableViewDelegate, UITableViewDataSource {
    func setupDaysView() {
        view.addSubview(daysView)
        navigationItem.title = "Days and travelers".localized()
        
        daysView.daysTableView.delegate = self
        daysView.daysTableView.dataSource = self
        
        daysView.numberPickerTableView.delegate = self
        daysView.numberPickerTableView.dataSource = self

        daysView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if edit {
            if roadmap.isPublic {
                daysView.publicSwitch.isOn = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == daysView.daysTableView {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellTable = UITableViewCell()
        
        if tableView == daysView.daysTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as? DatePickerTableViewCell {
                if indexPath.row == 0 {
                    cell.label.text = "Start date".localized()
                    cell.setupSeparator()
                    if edit {
                        cell.datePicker.date = editRoadmap.date ?? Date()
                    }
                    self.initialDate = cell.datePicker
                } else {
                    cell.label.text = "End date".localized()
                    if edit {
                        let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(editRoadmap.dayCount) - 1, to: editRoadmap.date ?? Date())
                        cell.datePicker.date = modifiedDate ?? Date()
                    }
                    self.finalDate = cell.datePicker

                }
                cell.datePicker.minimumDate = Date()
                cellTable = cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath) as? NumberPickerTableViewCell {
                cell.label.text = "Number of travelers".localized()
                if edit {
                    cell.numberPicker.selectRow(Int(editRoadmap.peopleCount) - 1, inComponent: 0, animated: true)
                }
                self.travelersCount = cell.numberPicker
                cellTable = cell
            }
        }
        
        return cellTable
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
