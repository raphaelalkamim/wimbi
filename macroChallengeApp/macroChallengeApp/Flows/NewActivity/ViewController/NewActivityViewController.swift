//
//  NewActivityViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 14/09/22.
//

import Foundation
import UIKit

protocol ChangeTextTableDelegate: AnyObject {
    func changeText(address: String)
}

class NewActivityViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let newActivityView = NewActivityView()
    var currencyType: String = "R$" {
        didSet {
            newActivityView.valueTable.reloadData()
        }
    }
    var fonts: [UIFont]! {
        didSet {
            // tableView.reloadData()
        }
    }
    var activity: Activity = Activity(id: 0, name: "Address", category: "", location: "", hour: "", budget: 0, day: Day(isSelected: true, date: Date()))
    
    var day = DayLocal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewActivityView()
        setKeyboard()
        
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelCreation))
        cancelButton.tintColor = .systemRed
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let salvarButton = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(saveActivity))
        self.navigationItem.rightBarButtonItem = salvarButton

    }
    
    override func viewWillAppear(_ animated: Bool) {
        newActivityView.localyTable.reloadData()
        print(activity.name)

    }
    
    @objc func cancelCreation() {
        coordinator?.backPage()
    }
    
    @objc func saveActivity() {
        self.getData()
        let newActivity = ActivityRepository.shared.createActivity(day: self.day, activity: self.activity)
        print(newActivity)
        coordinator?.backPage()
    }
    
    func getData() {
        // local name
        let tableView = newActivityView.localyTable
        guard let cell = tableView.cellForRow(at: [0, 1]) as? TextFieldTableViewCell else { return }
        activity.name = cell.title.text ?? "Nova atividade"

        // date
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        activity.day = Day(isSelected: true, date: formater.date(from: self.day.date ?? "23/10/2000") ?? Date())
        
        // hour
        let tableViewHour = newActivityView.dateTable
        guard let cell = tableViewHour.cellForRow(at: [0, 1]) as? TimePickerTableViewCell else { return }
        formater.dateStyle = .none
        formater.timeStyle = .short
        activity.hour = formater.string(from: cell.datePicker.date)
        
        // value
        let tableViewValue = newActivityView.valueTable
        guard let cell = tableViewValue.cellForRow(at: [0, 1]) as?
                ValueTableViewCell else { return }
        activity.budget = (cell.value.text as? NSString)?.doubleValue ?? 150.00
    }
}

extension NewActivityViewController {
    func setupNewActivityView() {
        navigationItem.title = "New Activity"
        view.addSubview(newActivityView)
        setupConstraints()
        newActivityView.bindTableView(delegate: self, dataSource: self)
        newActivityView.bindCollectionView(delegate: self, dataSource: self)
    }
    func setupConstraints() {
        newActivityView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NewActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if tableView == newActivityView.localyTable {
            rows = 2
        } else if tableView == newActivityView.dateTable {
            rows = 2
        } else if tableView == newActivityView.valueTable {
            rows = 2
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == newActivityView.localyTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as? AddressTableViewCell else { fatalError("TableCell not found") }
                newCell.label.text = activity.name
                newCell.setupSeparator()
                cell = newCell
                
            } else if indexPath.row == 1 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { fatalError("TableCell not found") }
                newCell.title.placeholder = "Name"
                cell = newCell
            }
            
        } else if tableView == newActivityView.dateTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as? DatePickerTableViewCell else { fatalError("TableCell not found") }
                newCell.label.text = "Date"
                newCell.setupSeparator()
                
                cell = newCell
            } else if indexPath.row == 1 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TimePickerTableViewCell.identifier, for: indexPath) as? TimePickerTableViewCell else { fatalError("TableCell not found") }
                newCell.label.text = "Hour"
                cell = newCell
            }
            
        } else if tableView == newActivityView.valueTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as? CurrencyTableViewCell else { fatalError("TableCell not found") }
                newCell.label.text = "Currency"
                newCell.setupSeparator()
                newCell.delegate = self
                cell = newCell
            } else {
                if indexPath.row == 1 {
                    guard let newCell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as? ValueTableViewCell else { fatalError("TableCell not found") }
                    
                    newCell.title.text = "Value"
                    newCell.currencyType = self.currencyType
                    newCell.value.placeholder = "$ 0.00"
                    cell = newCell
                }
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == newActivityView.localyTable {
            if indexPath.row == 0 {
                self.coordinator?.openLocationActivity(delegate: self)
            }
            if indexPath.row == 1 {
                
            }
        } else if tableView == newActivityView.valueTable {
            if indexPath.row == 1 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as? ValueTableViewCell else { fatalError("TableCell not found") }
            }
        }
    }
}

extension NewActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

extension NewActivityViewController {
    fileprivate func setKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissMissKeyboard))
        
        newActivityView.valueTable.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            newActivityView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            newActivityView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardSize.height, right: 0)}
    }
    
    @objc func dissMissKeyboard() {
        view.endEditing(true)
    }
}

extension NewActivityViewController: CurrencyTableViewCellDelegate {
    func didChangeFormatter(formatter: String) {
        self.currencyType = formatter
    }
}

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
            cell.iconDescription.text = "Food"
            cell.icon.image = designSystem.imagesActivities.food
        case 1:
            cell.iconDescription.text = "Accommodation"
            cell.icon.image = designSystem.imagesActivities.accomodation
        case 2:
            cell.iconDescription.text = "Leisure"
            cell.icon.image = designSystem.imagesActivities.leisure
        case 3:
            cell.iconDescription.text = "Transportation"
            cell.icon.image = designSystem.imagesActivities.transportation
        default:
            break
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryActivityCollectionViewCell {
            switch cell.iconDescription.text {
            case "Accommodation":
                cell.selectedBackgroundView(button: "accommodation")
                activity.category = "accommodation"
            case "Food":
                cell.selectedBackgroundView(button: "food")
                activity.category = "food"
            case "Leisure":
                cell.selectedBackgroundView(button: "leisure")
                activity.category = "leisure"
            case "Transportation":
                cell.selectedBackgroundView(button: "transportation")
                activity.category = "transportation"
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryActivityCollectionViewCell {
            switch cell.iconDescription.text {
            case "Accommodation":
                cell.notSelectedBackgroundView(button: "accommodation")
            case "Food":
                cell.notSelectedBackgroundView(button: "food")
            case "Leisure":
                cell.notSelectedBackgroundView(button: "leisure")
            case "Transportation":
                cell.notSelectedBackgroundView(button: "transportation")
            default:
                break
            }
        }
    }
    
}

extension NewActivityViewController: ChangeTextTableDelegate {
    func changeText(address: String) {
        activity.location = address
        newActivityView.localyTable.reloadData()
    }
}
