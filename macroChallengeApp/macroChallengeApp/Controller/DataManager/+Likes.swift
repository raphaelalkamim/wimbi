//
//  +Likes.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 21/11/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAnalytics

extension DataManager {
    // MARK: - POST
    func postLike(roadmapId: Int, _ completion: @escaping ((_ response: Int) -> Void)) {
        let session: URLSession = URLSession.shared
        
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            let url: URL = URL(string: baseURL + "users/\(userID)/roadmaps/\(roadmapId)/likes")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if let token = UserDefaults.standard.string(forKey: "authorization") {
                request.setValue(token, forHTTPHeaderField: "Authorization")
                let task = session.dataTask(with: request) { data, response, error in
                    print(response)
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    
                    do {
                        let stringInt = String(data: data, encoding: String.Encoding.utf8)
                        var likeId: Int = 0
                        if let likeIdConvert = Int(stringInt ?? "0") {
                            likeId = likeIdConvert
                        }
                        DispatchQueue.main.async {
                            completion(likeId)
                        }
                    } catch {
                        print(error)
                        print("DEU RUIM NO PARSE")
                    }
                }
                task.resume()
            }
            
        }
    }
    // MARK: - GET
    func getLike(roadmapId: Int, _ completion: @escaping ((_ response: Int) -> Void)) {
        let session: URLSession = URLSession.shared
        
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            print(userID)
            let url: URL = URL(string: baseURL + "likes/users/\(userID)/roadmaps/\(roadmapId)")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if let token = UserDefaults.standard.string(forKey: "authorization") {
                request.setValue(token, forHTTPHeaderField: "Authorization")
                let task = session.dataTask(with: request) { data, _, error in
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    
                    do {
                        let stringInt = String(data: data, encoding: String.Encoding.utf8)
                        var likeId: Int = 0
                        if let likeIdConvert = Int(stringInt ?? "0") {
                            likeId = likeIdConvert
                        }
                        DispatchQueue.main.async { completion(likeId) }
                    } catch {
                        print(error)
                        print("DEU RUIM NO PARSE")
                    }
                }
                task.resume()
            }
        }
    }
    func getLikedRoadmaps(_ completion: @escaping ((_ roadmaps: [RoadmapDTO]) -> Void)) {
        var roadmaps: [RoadmapDTO] = []
        let session: URLSession = URLSession.shared
        
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            let url: URL = URL(string: baseURL + "likes/users/\(userID)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if let token = UserDefaults.standard.string(forKey: "authorization") {
                request.setValue(token, forHTTPHeaderField: "Authorization")
                let task = session.dataTask(with: request) { data, _, error in
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    
                    do {
                        roadmaps = try JSONDecoder().decode([RoadmapDTO].self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(roadmaps)
                        }
                    } catch {
                        print("DEU RUIM NO PARSE")
                    }
                }
                task.resume()
            }
        }
    }
}
