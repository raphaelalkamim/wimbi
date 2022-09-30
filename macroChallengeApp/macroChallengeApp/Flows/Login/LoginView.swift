//
//  LoginView.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 14/09/22.
//

import UIKit
import AuthenticationServices

class LoginView: UIView {
    let designSystem = DefaultDesignSystem.shared
    let signInWithAppleManager = SignInWithAppleManager.shared
    let isLogged = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    lazy var imageLogin: UIImageView = {
        let image = UIImageView()
        if isLogged {
            image.backgroundColor = .green
        } else {
            image.backgroundColor = .red
        }
        return image
    }()
    
    lazy var loginText: UILabel = {
        let label = UILabel()
        label.text = "FAZER TEXTIN"
        return label
    }()
    
    lazy var agreeText: UILabel = {
        let label = UILabel()
        label.text = "By clicking on the button above, you agree to our privacy policies".localized()
        return label
    }()
    
    lazy var buttonAppleSignIn: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.cornerRadius = 108
        button.addTarget(self, action: #selector(actionButtonSignIn), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = designSystem.palette.backgroundPrimary
        
        self.addSubview(imageLogin)
        self.addSubview(loginText)
        self.addSubview(buttonAppleSignIn)
        self.addSubview(agreeText)
        
        setupConstraints()
        
        loginText.stylize(with: designSystem.text.caption)
        agreeText.stylize(with: designSystem.text.caption)
        
        agreeText.textAlignment = .center
        agreeText.textColor = .black
        agreeText.font = UIFont(name: "Avenir-Roman", size: 12)!
    }
    
    func setupConstraints() {
        imageLogin.snp.makeConstraints { make in
            make.top.equalTo(self.snp.topMargin).offset(60)
            make.height.width.equalTo(282)
            make.leading.equalToSuperview().offset(54)
            make.trailing.equalToSuperview().offset(-54)
        }
        
        loginText.snp.makeConstraints { make in
            make.top.equalTo(imageLogin.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        buttonAppleSignIn.snp.makeConstraints { make in
            make.top.equalTo(loginText.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(51)
        }
        
        agreeText.snp.makeConstraints { make in
            make.top.equalTo(buttonAppleSignIn.snp.bottom).offset(designSystem.spacing.xxLargePositive)
            make.leading.equalToSuperview().offset(87)
            make.trailing.equalToSuperview().offset(-87)
            
        }
    }
    
    @objc func actionButtonSignIn() {
        signInWithAppleManager.signIn()
    }
    
}
