//
//  DataManager.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation
import UIKit

class DataManager {
    public static var shared = DataManager()
    let baseURL: String = "https://macroptrip-api.herokuapp.com/"
    
    public let imageCash = NSCache<NSNumber, UIImage>()
    
    var roadmaps: Roadmaps?
    var user: User?
    var activity: Activity?
    var day: Day?
    var like: Like?
    
    // MARK: - Load Data
    public func loadData(_ completion: @escaping (() -> Void), dataURL: String, dataType: DataType) {
        let session = URLSession.shared
        let url = URL(string: baseURL + dataURL)!
        
        // resposta vem no data (json), error vem no error
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            self.getDataType(dataType: dataType, data: data)
        }
        task.resume()
    }
    
    private func getDataType(dataType: DataType, data: Data ) {
        switch dataType {
        case .USER:
            do {
                self.user = try JSONDecoder().decode(User.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .ROADMAPS:
            do {
                self.roadmaps = try JSONDecoder().decode(Roadmaps.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .ACTIVITY:
            do {
                self.activity = try JSONDecoder().decode(Activity.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .DAY:
            do {
                self.day = try JSONDecoder().decode(Day.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .LIKE:
            do {
                self.like = try JSONDecoder().decode(Like.self, from: data)
            } catch {
                print("Parse Error")
            }
        }
    }
    
    func postUser(username: String, usernameApp:String, name: String, photoId: String, password: String) {
        let user: [String: Any] = [
            "username": username,
            "usernameApp": usernameApp,
            "name": name,
            "photoId": photoId,
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
            print(response)
            if let error = error {
                print(error)
            } else if data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Criou")
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
            print(response)
            if let error = error {
                print(error)
            } else if data == data {
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
                    }
                }
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
    }
    
    // swiftlint:disable function_parameter_count
    func postRoadmap(name: String, location: String, dayCount: Int, peopleCount: Int, imageId: String, category: String, isShared: Bool, isPublic: Bool) {
        let roadmap: [String: Any] = [
            "name": name,
            "location": location,
            "budget": 0,
            "dayCount": dayCount,
            "peopleCount": peopleCount,
            "imageId": imageId,
            "category": category,
            "isShared": isShared,
            "isPublic": isPublic,
            "shareKey": "ABC123"
        ]
        
        let session = URLSession.shared
        guard let url = URL(string: baseURL + "roadmaps") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: roadmap, options: .prettyPrinted)
            } catch {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request) { data, response, error in
                print(response)
                if let error = error {
                    print(error)
                } else if data == data {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("Criou Roadmap")
                        }
                    }
                } else {
                    // Handle unexpected error
                }
            }
            task.resume()
        }
        
        
    }
    
#warning("Corrigir essa funcao para utilizar no codigo")
    func decodeType<T: Codable>(_ class: T, data: Data) -> T? {
        do {
            let newData = try JSONDecoder().decode(T.self, from: data)
            return newData
        } catch {
            print("Parse Error")
        }
        return nil
    }
}
