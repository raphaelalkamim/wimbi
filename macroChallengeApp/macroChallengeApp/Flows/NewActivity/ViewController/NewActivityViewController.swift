//
//  NewActivityViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 14/09/22.
//

import Foundation
import UIKit

class NewActivityViewController: UIViewController {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let newActivityView = NewActivityView()
    var fonts: [UIFont]! {
        didSet {
            //tableView.reloadData()
        }
    }
    
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
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { fatalError("TableCell not found") }
                
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
                
                let separator = UIView()
                
                newCell.addSubview(separator)
                separator.backgroundColor = .gray
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                    make.trailing.equalToSuperview()
                }
                cell = newCell
            } else if indexPath.row == 1 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TimePickerTableViewCell.identifier, for: indexPath) as? TimePickerTableViewCell else { fatalError("TableCell not found") }
                
                newCell.label.text = "Hour"
                cell = newCell
            }
            
        } else if tableView == newActivityView.valueTable {
            if indexPath.row == 0 {
                guard let newCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { fatalError("TableCell not found") }
                newCell.title.text = "Currency"
                
                let separator = UIView()
                
                newCell.addSubview(separator)
                separator.backgroundColor = .gray
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                    make.trailing.equalToSuperview()
                }
                
                cell = newCell
                
            } else {
                if indexPath.row == 1 {
                    guard let newCell = tableView.dequeueReusableCell(withIdentifier: ValueTableViewCell.identifier, for: indexPath) as? ValueTableViewCell else { fatalError("TableCell not found") }
                    
                    newCell.title.text = "Value"
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
                //self.navigationController?.pushViewController(), animated: true)
            }
        }
        
        else if tableView == newActivityView.valueTable {
            if indexPath.row == 0 {}
        }
    }
}

extension NewActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions -> UIMenu? in
//            let font = self.fonts[indexPath.row]
//            let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, handler: <#UIActionHandler#>)
//            
//        }
//        return UIMenu(title: "A", image: nil, identifier: nil, options: [], children: [copyAction])
//    }
//    
}
