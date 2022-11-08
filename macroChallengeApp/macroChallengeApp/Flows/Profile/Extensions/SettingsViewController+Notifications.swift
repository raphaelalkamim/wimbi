//
//  SettingsViewController+EditProfile.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 19/09/22.
//

import Foundation
import UIKit

extension NotificationsViewController {
    func setupNotificationsView() {
        view.addSubview(notificationsView)
        setupConstraints()
    }
    func setupConstraints() {
        notificationsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension NotificationsViewController: UITableViewDelegate {
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        guard let cellPicker = tableView.dequeueReusableCell(withIdentifier: NotificationPickerTableViewCell.identifier, for: indexPath) as? NotificationPickerTableViewCell else {
            preconditionFailure("Cell not find")
        }
        guard let cellSwitch = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
            preconditionFailure("Cell not find")
        }

        switch indexPath.row {
        case 0:
            cellSwitch.title.text = "Turn on notification".localized()
            cellSwitch.switchButton.onTintColor = .accent
            cellSwitch.backgroundColor = designSystem.palette.backgroundCell
            cell = cellSwitch

        case 1:
            cellPicker.setup()
            cellPicker.title.text = "Frequency".localized()
            cellPicker.backgroundColor = designSystem.palette.backgroundCell
            cellPicker.picker.selectRow(UserDefaults.standard.integer(forKey: "number"), inComponent: 0, animated: true)
            cellPicker.picker.selectRow(UserDefaults.standard.integer(forKey: "interval"), inComponent: 1, animated: true)
            cell = cellPicker
            
        default:
            break
        }
        
        return cell

    }
    
}
