//
//  SignInWithAppleManager.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 14/09/22.
//

import AuthenticationServices

class SignInWithAppleManager: NSObject, ASAuthorizationControllerDelegate {
    static var shared = SignInWithAppleManager()
    
    override private init() {
    }
    
    var userId: String?
    var fullName: PersonNameComponents?
    var emailId: String?
    let dataManager = DataManager.shared
    
    func signIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            // pegar infos
            userId = appleIDCredential.user
            fullName = appleIDCredential.fullName
            emailId = appleIDCredential.email
            
            guard let userId = userId else {
                return
            }
            
            let delimiter2 = "."
            let codeComponents = userId.components(separatedBy: delimiter2)
            let code = codeComponents[1] + codeComponents[0]
            
            if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
                let username = String(data: data, encoding: .utf8)!
                dataManager.postLogin(username: username, password: code)
            } else {
                let delimiter = "@"
                let username = emailId?.components(separatedBy: delimiter)
                
                guard let usernameApp = username?[0] else { return }
                guard let fullName = fullName else { return }
                dataManager.postUser(username: userId, usernameApp: usernameApp, name: "\(fullName.givenName) \(fullName.familyName)", photoId: "teste1", password: code)
                dataManager.postLogin(username: userId, password: code)
            }
            
        }
    }
    
    func checkUserStatus() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        if let userId = userId {
            appleIDProvider.getCredentialState(forUserID: userId) {  (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    print("autho")
                case .revoked:
                    // The Apple ID credential is revoked.
                    print("revoked")
                case .notFound:
                    // No credential was found, so show the sign-in UI.
                    print("notFound")
                default:
                    break
                }
            }
        } else {
            print("Not found user")
        }
    }
    
}
