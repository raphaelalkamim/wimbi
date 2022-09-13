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
        
        daysView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //swiftlint: disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    //swiftlint: enable force_cast

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
