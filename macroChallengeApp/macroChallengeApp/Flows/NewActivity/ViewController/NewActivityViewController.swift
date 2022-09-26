//
//  NewActivityViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 14/09/22.
//

import Foundation
import UIKit

class NewActivityViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let newActivityView = NewActivityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewActivityView()
    }
}

extension NewActivityViewController {
    func setupNewActivityView() {
        navigationItem.title = "New Activitie"
        view.addSubview(newActivityView)
        setupConstraints()
        
        newActivityView.bindColletionView(delegate: self, dataSource: self)
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
        if tableView == newActivityView.categoryTable {
            rows = 1
        } else if tableView == newActivityView.localyTable {
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
        if tableView == newActivityView.categoryTable {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: StackTableViewCell.identifier, for: indexPath) as? StackTableViewCell else { fatalError("TableCell not found") }
            
            newCell.title.text = "Category"
            cell = newCell
            
        } else if tableView == newActivityView.localyTable {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { fatalError("TableCell not found") }
            
            if indexPath.row == 0 {
                newCell.title.placeholder = "Address"
                
                let separator = UIView()
                
                newCell.addSubview(separator)
                separator.backgroundColor = .gray
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                    make.trailing.equalToSuperview()
                }
                
            } else {
                newCell.title.placeholder = "Name"
            }
            
            cell = newCell
            
        } else if tableView == newActivityView.dateTable {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as? DatePickerTableViewCell else { fatalError("TableCell not found") }
            
            if indexPath.row == 0 {
                newCell.label.text = "Date"
                
                let separator = UIView()
                
                newCell.addSubview(separator)
                separator.backgroundColor = .gray
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                    make.trailing.equalToSuperview()
                }
                
            } else {
                newCell.label.text = "Hour"
            }
            
            cell = newCell
            
        } else if tableView == newActivityView.dateTable {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as? DatePickerTableViewCell else { fatalError("TableCell not found") }
            
            if indexPath.row == 0 {
                newCell.label.text = "Date"
                
                let separator = UIView()
                
                newCell.addSubview(separator)
                separator.backgroundColor = .gray
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                    make.trailing.equalToSuperview()
                }
                
            } else {
                newCell.label.text = "Hour"
            }
            
            cell = newCell
            
        } else if tableView == newActivityView.valueLabel {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as? DatePickerTableViewCell else { fatalError("TableCell not found") }
            
            if indexPath.row == 0 {
                newCell.label.text = "Date"
                
                let separator = UIView()
                
                newCell.addSubview(separator)
                separator.backgroundColor = .gray
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                    make.trailing.equalToSuperview()
                }
                
            } else {
                newCell.label.text = "Hour"
            }
            cell = newCell
        }
        return cell
    }
}

extension NewActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
