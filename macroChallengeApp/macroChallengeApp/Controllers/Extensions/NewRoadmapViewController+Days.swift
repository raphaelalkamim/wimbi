//
//  NewRoadmapViewController+Days.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 13/09/22.
//

import Foundation
import UIKit

extension NewRoadmapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupDaysView() {
        view.addSubview(daysView)
        navigationItem.title = "Dias e viajantes"
        
        daysView.daysTableView.delegate = self
        daysView.daysTableView.dataSource = self
        
        daysView.numberPickerTableView.delegate = self
        daysView.numberPickerTableView.dataSource = self

        
        daysView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == daysView.daysTableView {
            return 2
        } else {
            return 1
        }
    }
    
    //swiftlint: disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == daysView.daysTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DatePickerTableViewCell
            
            if indexPath.row == 0 {
                cell.label.text = "Começa"
                let separator = UIView()
                cell.addSubview(separator)
                separator.backgroundColor = .gray
                
                separator.snp.makeConstraints { make in
                    make.height.equalTo(0.5)
                    make.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(designSystem.spacing.largePositive)
                    make.trailing.equalToSuperview()

                }
            } else {
                cell.label.text = "Termina"
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath) as! NumberPickerTableViewCell

            cell.label.text = "Quantidade de viajantes"
            return cell
        }
    }
    //swiftlint: enable force_cast

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
