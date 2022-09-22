//
//  EditProfileView.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import SnapKit

class EditProfileView: UIView {
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageProfile: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "categoryBeach")
        img.clipsToBounds = true
        return img
    }()
    
    lazy var nameLabel: UILabel = {
        let title = UILabel()
        title.text = "NOME" // adicionar nome
        title.stylize(with: designSystem.text.caption)
        title.textColor = .caption
        return title
    }()
    
    lazy var usernameLabel: UILabel = {
        let title = UILabel()
        title.text = "NOME DO USUÁRIO" // adicionar nome
        title.stylize(with: designSystem.text.caption)
        title.textColor = .caption
        return title
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .backgroundCell
        textField.font = .body
        textField.isEnabled = true
        textField.layer.masksToBounds = true
        textField.borderStyle = .none
        textField.text = "Malcon Cardoso"
        textField.layer.cornerRadius = 14
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        textField.keyboardType = .default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = UITextField.ViewMode.never
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .backgroundCell
        textField.font = .body
        textField.isEnabled = true
        textField.layer.masksToBounds = true
        textField.borderStyle = .none
        textField.text = "@malcon"
        textField.layer.cornerRadius = 14
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        textField.keyboardType = .default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = UITextField.ViewMode.never
        textField.isUserInteractionEnabled = true
        return textField
    }()
        
    func setup() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        self.addSubview(contentView)
        contentView.addSubview(imageProfile)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(usernameTextField)
        setupConstraints()
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.right.equalTo(self)
        }
        
        imageProfile.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin).inset(designSystem.spacing.mediumPositive)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
            make.width.equalTo(120)

        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageProfile.snp.bottom).inset(designSystem.spacing.xxLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(32)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)

        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(44)

        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).inset(designSystem.spacing.xxLargeNegative)
            make.leading.equalTo(contentView.snp.leading).inset(32)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)

        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).inset(designSystem.spacing.smallNegative)
            make.leading.equalTo(contentView.snp.leading).inset(designSystem.spacing.xLargePositive)
            make.trailing.equalTo(contentView.snp.trailing).inset(designSystem.spacing.xLargePositive)
            make.height.equalTo(44)

        }
    }
}
