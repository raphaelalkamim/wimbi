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
            if let authorizationCode = appleIDCredential.authorizationCode {
                let authCode = String(decoding: authorizationCode, as: Unicode.ASCII.self)
                createToken(code: authCode)
            }
            
            guard let userId = userId else {
                return
            }
            
            let delimiter2 = "."
            let codeComponents = userId.components(separatedBy: delimiter2)
            let code = codeComponents[1] + codeComponents[0]
            
            KeychainManager.shared.delete(service: "username", account: "explorer")
            var username = ""
            
            if emailId == nil {
                let usernamesTags = ["explorer", "traveler", "passenger", "tourist", "visitor"]
                username = (usernamesTags.randomElement() ?? "stranger") + "\(Int.random(in: 100_000...900_000))"
            } else {
                let delimiter = "@"
                let usernameComps = emailId?.components(separatedBy: delimiter)
                if let usernameOk = usernameComps?[0] {
                    username = usernameOk
                }
                
            }
            
            if let fullName = fullName {
                dataManager.postUser(username: userId, usernameApp: username, name: "\(fullName.givenName ?? "New") \(fullName.familyName ?? "Traveler")", photoId: "categoryCamp", password: code, {
                    self.dataManager.postLogin(username: userId, password: code)
                })
            }
        }
    }
    
    func createToken(code: String) {
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: DataManager.shared.baseURL + "appleToken/" + code)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let refreshToken = try JSONDecoder().decode(RefreshToken.self, from: data)
                        do {
                            try KeychainManager.shared.save(refreshToken.accessToken, service: "signInRefresh", account: "explorer")
                        } catch {
                            print(error)
                        }
                        print(refreshToken)
                    } catch {
                        print(error)
                    }
                }
            }
            
        }
        task.resume()
        
    }
    
    func revokeToken() {
        let session: URLSession = URLSession.shared
        
        if let data = KeychainManager.shared.read(service: "signInRefresh", account: "explorer") {
            let refreshToken = String(data: data, encoding: .utf8)!
            
            let url: URL = URL(string: DataManager.shared.baseURL + "appleToken/" + refreshToken)!
            
            if let token = UserDefaults.standard.string(forKey: "authorization") {
                var request = URLRequest(url: url)
                request.setValue(token, forHTTPHeaderField: "Authorization")
                request.httpMethod = "DELETE"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = session.dataTask(with: request) { data, _, error in
                    guard let data = data else { return }
                    
                    let refreshToken = String(data: data, encoding: .utf8) ?? ""
                    print(refreshToken)
                    
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    
                }
                task.resume()
            }
        }
    }
    
    func checkUserStatus() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            appleIDProvider.getCredentialState(forUserID: userID) { credentialState, _ in
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    print("autho arroz")
                case .revoked:
                    // The Apple ID credential is revoked.
                    print("revoked arroz")
                case .notFound:
                    // No credential was found, so show the sign-in UI.
                    print("notFound arroz")
                default:
                    break
                }
            }
        } else {
            print("Not found user")
        }
    }
    
}
