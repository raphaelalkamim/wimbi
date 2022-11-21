//
//  +User.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 21/11/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAnalytics

extension DataManager {
    // MARK: - Post
    func postUser(username: String, usernameApp: String, name: String, photoId: String, password: String, _ completion: @escaping (() -> Void)) {
        let user: [String: Any] = [
            "username": username,
            "usernameApp": usernameApp,
            "name": name,
            "photoId": "icon",
            "password": password
        ]
        
        let session = URLSession.shared
        guard let url = URL(string: baseURL + "users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        completion()
                    }
                    if httpResponse.statusCode == 200 {
                        print("Criou")
                        FirebaseManager.shared.createAnalyticsEvent(event: AnalyticsEventSignUp)

                    }
                    
                }
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
    }
    func postLogin(username: String, password: String) {
        let user: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        let session = URLSession.shared
        guard let url = URL(string: baseURL + "login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            try KeychainManager.shared.save(username, service: "username", account: "explorer")
                        } catch {
                            print(error)
                        }
                        
                        let jwtToken = httpResponse.value(forHTTPHeaderField: "Authorization")
                        UserDefaults.standard.setValue(jwtToken, forKey: "authorization")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        
                        FirebaseManager.shared.createAnalyticsEvent(event: AnalyticsEventLogin)

                        DispatchQueue.main.async { self.delegate?.finishLogin() }
                    }
                }
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
    }
    // MARK: - Get
    func getUser(username: String, _ completion: @escaping ((_ user: User) -> Void)) {
        var user: User?
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + "users/\(username)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data else { return }
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
                
                do {
                    user = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async { completion(user!) }
                } catch {
                    print(error)
                }
            }
            task.resume()
            
        }
    }
    // MARK: - PUT
    func putUser(userObj: UserLocal) {
        let user: [String: Any] = [
            "usernameApp": userObj.usernameApp ?? "newuser",
            "name": userObj.name ?? "newuser",
            "photoId": "icon"
        ]
        
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            
            let session = URLSession.shared
            guard let url = URL(string: baseURL + "users/\(userID)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
            } catch {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if let token = UserDefaults.standard.string(forKey: "authorization") {
                request.setValue(token, forHTTPHeaderField: "Authorization")
                let task = session.dataTask(with: request) { data, _, error in
                    if let error = error {
                        print(error)
                    } else if data != nil {
                    } else {
                        // Handle unexpected error
                    }
                }
                task.resume()
            }
        }
    }
    // MARK: -- DELETE
}
