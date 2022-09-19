//
//  ProfileViewController+Settings.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 17/09/22.
//

import Foundation
import UIKit

extension SettingsViewController {
    func setupSettingsView() {
        view.addSubview(settingsView)
        setupConstraints()
    }
    func setupConstraints() {
        settingsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Ação editar perfil")
        
        case 1:
            print("Ação roteiros curtidos")
        
        case 2:
            print("Ação notificações")
        
        case 3:
            print("Ação termos")
        
        case 4:
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.view.tintColor = .accent
            let titleAtt = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 17)]
            let string = NSAttributedString(string: "Sair da sua conta?", attributes: titleAtt)
            alert.setValue(string, forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            }))
            alert.addAction(UIAlertAction(title: "Sair", style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                    // Ação Cancelar
            }))
            present(alert, animated: true)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            preconditionFailure("Cell not find")
        }
        cell.setup()
        cell.backgroundColor = designSystem.palette.backgroundCell

        switch indexPath.row {
        case 0:
            cell.title.text = "Editar perfil"
            cell.icon.setImage(UIImage(systemName: "person.fill"), for: .normal)
        
        case 1:
            cell.title.text = "Roteiros curtidos"
            cell.icon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        case 2:
            cell.title.text = "Notificações"
            cell.icon.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        
        case 3:
            cell.title.text = "Termos de privacidade"
            cell.icon.setImage(UIImage(systemName: "book.closed.fill"), for: .normal)
        
        case 4:
            cell.title.text = "Sair"
            cell.title.textColor = .redCity
            cell.icon.isHidden = true
            cell.chevron.isHidden = true
            cell.title.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(designSystem.spacing.largePositive)
            }
        default:
            break
        }
        
        return cell

    }
    
}
