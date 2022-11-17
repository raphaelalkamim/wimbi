//
//  NewActivityExtension.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 29/09/22.
//

import Foundation
import UIKit

// MARK: Protocolos
protocol AddNewActivityDelegate: AnyObject {
    func attTable()
}
protocol ChangeTextTableDelegate: AnyObject {
    func changeText(coords: String, locationName: String, address: String)
}

extension NewActivityViewController {
    func setupNewActivityView() {
        navigationItem.title = "New activity".localized()
        newActivityView.bindTableView(delegate: self, dataSource: self)
        newActivityView.bindCollectionView(delegate: self, dataSource: self)
    }
    func setupConstraints() {
        newActivityView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func getData() {
        self.activity.currency = activityEdit.currencyType ?? "R$"
        self.currencyType = self.activity.currency
        self.activity.location = activityEdit.location ?? "Coord"
        self.activity.hour = activityEdit.hour ?? "23/10/2000"
        self.activity.name = activityEdit.name ?? "No name"
        self.activity.budget = activityEdit.budget
        self.activity.tips = activityEdit.tips ?? "Details"
        self.activity.category = activityEdit.category ?? "empty"
        self.activity.address = activityEdit.address ?? "Address"
        self.activity.link = activityEdit.link ?? "www"
        self.address = activityEdit.address ?? "Address"
        self.activity.tips = activityEdit.tips ?? ""
    }
    
    // MARK: Save new Activity functions
    func setData() {
        // local name
        let tableView = newActivityView.localyTable
        guard let cell = tableView.cellForRow(at: [0, 1]) as? TextFieldTableViewCell else { return }
        activity.name = cell.title.text ?? "New activity".localized()
        if activity.name == "" { activity.name = "New activity".localized() }

        // date
        let dateTable = newActivityView.dateTable
        guard let cell = dateTable.cellForRow(at: [0, 0]) as? DatePickerTableViewCell else { return }
        
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        activity.day = Day(isSelected: true, date: cell.datePicker.date)
        
        // hour
        guard let cell = dateTable.cellForRow(at: [0, 1]) as? TimePickerTableViewCell else { return }
        formater.dateStyle = .none
        formater.timeStyle = .short
        activity.hour = formater.string(from: cell.datePicker.date)
        
        // value
        let tableViewValue = newActivityView.valueTable
        guard let cell = tableViewValue.cellForRow(at: [0, 1]) as?
                ValueTableViewCell else { return }
        let newValue = cell.getNumber(textNumber: cell.value.text ?? "123", userCurrency: self.userCurrency)
        activity.budget = Double(newValue) ?? 0.0
        activity.currency = self.currencyType
        
        // tips
        let tableViewDetail = newActivityView.detailTable
        guard let cell = tableViewDetail.cellForRow(at: [0, 0]) as? DetailTableViewCell else { return }
        activity.tips = cell.detailText.text ?? "Details"
        
        // link
        let tableViewLink = newActivityView.contactTable
        guard let cell = tableViewLink.cellForRow(at: [0, 0]) as? TextFieldTableViewCell else { return }
        activity.link = cell.title.text ?? "Contact".localized()
    }
}

// MARK: Table View
extension NewActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if tableView == newActivityView.localyTable {
            rows = 2
        } else if tableView == newActivityView.dateTable {
            rows = 2
        } else if tableView == newActivityView.valueTable {
            rows = 2
        } else if tableView == newActivityView.detailTable {
            rows = 1
        } else if tableView == newActivityView.contactTable {
            rows = 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == newActivityView.localyTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell else { fatalError("TableCell not found") }
                if address.isEmpty {
                    newCell.label.text = "Address".localized()
                } else {
                    newCell.label.text = self.address
                }
                newCell.setupSeparator()
                cell = newCell
                
            } else if indexPath.row == 1 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { fatalError("TableCell not found") }
                newCell.title.placeholder = "Name".localized()
                newCell.title.text = activity.name
                self.setupTextFields(textField: newCell.title)
                cell = newCell
            }
            
        } else if tableView == newActivityView.dateTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as? DatePickerTableViewCell else { fatalError("TableCell not found") }
                newCell.label.text = "Date".localized()
                newCell.setupDate(date: day.date ?? "23/10/2022",
                                  dateInitial: roadmap.date ?? Date(),
                                  dateFinal: roadmap.dateFinal ?? Date())
                newCell.setupSeparator()
                
                cell = newCell
            } else if indexPath.row == 1 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TimePickerTableViewCell.identifier, for: indexPath) as? TimePickerTableViewCell else { fatalError("TableCell not found") }
                newCell.label.text = "Hour".localized()
                if edit {
                    let format = DateFormatter()
                    format.dateStyle = .none
                    format.timeStyle = .short
                    newCell.datePicker.date = format.date(from: activityEdit.hour ?? "16h00") ?? Date()
                }
                cell = newCell
            }
            
        } else if tableView == newActivityView.valueTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as? CurrencyTableViewCell else { fatalError("TableCell not found") }
                newCell.setupSeparator()
                newCell.delegate = self
                newCell.label.text = "Currency".localized()
                newCell.setCurrencyLabel(currency: self.currencyType)
                cell = newCell
            } else if indexPath.row == 1 {
                    guard let newCell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as? ValueTableViewCell else { fatalError("TableCell not found") }
                    newCell.setCurrencyValue(currency: self.currencyType, value: activity.budget)
                    self.activity.currency = self.currencyType
                    cell = newCell
            }
        } else if tableView == newActivityView.detailTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else { fatalError("TableCell not found") }
                newCell.detailText.text = self.activity.tips
                self.setupTextView(textView: newCell.detailText)
                cell = newCell
                
            }
        } else if tableView == newActivityView.contactTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { fatalError("TableCell not found") }
                newCell.title.placeholder = "Contact".localized()
                newCell.title.text = activity.link
                self.setupTextFields(textField: newCell.title)
                cell = newCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == newActivityView.localyTable {
            if indexPath.row == 0 {
                self.coordinator?.openLocationActivity(delegate: self, roadmap: roadmap)
                print(roadmap)
            }
        }
    }
}

extension NewActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == newActivityView.detailTable {
            return 100
        } else {
            return 50
        }
    }
    
}
// MARK: CollectionView
extension NewActivityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}
extension NewActivityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryActivityCollectionViewCell.identifier, for: indexPath) as? CategoryActivityCollectionViewCell else {
            preconditionFailure("Cell not find")
        }
        switch indexPath.row {
        case 0:
            cell.iconDescription.text = "Food".localized()
            cell.icon.image = designSystem.imagesActivities.food
            if activity.category == "food" { cell.selectedBackgroundView(button: activity.category) }
        case 1:
            cell.iconDescription.text = "Accommodation".localized()
            cell.icon.image = designSystem.imagesActivities.accomodation
            if activity.category == "accommodation" { cell.selectedBackgroundView(button: activity.category) }
        case 2:
            cell.iconDescription.text = "Leisure".localized()
            cell.icon.image = designSystem.imagesActivities.leisure
            if activity.category == "leisure" { cell.selectedBackgroundView(button: activity.category) }
        case 3:
            cell.iconDescription.text = "Transportation".localized()
            cell.icon.image = designSystem.imagesActivities.transportation
            if activity.category == "transportation" { cell.selectedBackgroundView(button: activity.category) }
        default:
            break
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryActivityCollectionViewCell {
            activity.category = cell.setCellIcon(isSelected: true)
        }
        for index in 0..<4 where index != indexPath.row {
            let newIndexPath = IndexPath(item: Int(index), section: 0)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? CategoryActivityCollectionViewCell {
                _ = cell.setCellIcon(isSelected: false)
            }
        }
    }
}

// MARK: Delegates
extension NewActivityViewController: ChangeTextTableDelegate {
    func changeText(coords: String, locationName: String, address: String) {
        activity.location = coords
        activity.name = locationName
        activity.address = address
        self.address = activity.address
        newActivityView.localyTable.reloadData()
    }
}

extension NewActivityViewController: CurrencyTableViewCellDelegate {
    func didChangeFormatter(formatter: String) {
        self.currencyType = formatter
    }
}
