//
//  +Roadmaps.swift
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
    func postRoadmap(roadmap: Roadmap, days: [Day], selectedImage: UIImage? = nil) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let keyWords = ["trip", "viagem", "travel", "viaggiare"]
        let codeTrip = "\(Int.random(in: 0..<1_000_000))\(keyWords.randomElement() ?? "space")\(Int.random(in: 0..<1_000_000))"
        
        let roadmap: [String: Any] = [
            "name": roadmap.name,
            "location": roadmap.location,
            "budget": 0,
            "dayCount": roadmap.dayCount,
            "dateInitial": roadmap.dateInitial,
            "dateFinal": roadmap.dateFinal,
            "peopleCount": roadmap.peopleCount,
            "imageId": setupImage(category: roadmap.category),
            "category": roadmap.category,
            "isShared": roadmap.isShared,
            "isPublic": roadmap.isPublic,
            "shareKey": codeTrip,
            "createdAt": dateFormatter.string(from: Date()),
            "currency": roadmap.currency,
            "likesCount": 0
        ]
        
        let session = URLSession.shared
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            guard let url = URL(string: baseURL + "roadmaps/users/\(userID)") else { return }
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
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            do {
                                // tentar transformar os dados no tipo Cohort
                                let roadmapResponse = try JSONDecoder().decode(RoadmapDTO.self, from: data)
                                
                                self.postDays(roadmapId: roadmapResponse.id, daysCore: days)
                                if let selectedImage = selectedImage {
                                    FirebaseManager.shared.uploadImageRoadmap(image: selectedImage, roadmapId: roadmapResponse.id)
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    // MARK: - GET
    func getPublicRoadmaps(_ completion: @escaping ((_ roadmaps: [RoadmapDTO]) -> Void)) {
        var roadmaps: [RoadmapDTO] = []
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + "roadmaps")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
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
                print("Erro ao coletar roadmaps públicos")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }
    
    func getRoadmapById(roadmapId: Int, _ completion: @escaping ((_ roadmap: Roadmap?) -> Void)) {
        var roadmap: Roadmap?
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + "roadmaps/\(roadmapId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            
            do {
                roadmap = try JSONDecoder().decode(Roadmap.self, from: data)
            } catch {
                print(error)
                print(response)
                print("Erro ao coletar roadmap pelo ID")
            }
            
            DispatchQueue.main.async {
                completion(roadmap)
            }
        }
        task.resume()
    }
    
    func getRoadmapUserImage(roadmapId: Int, _ completion: @escaping ((_ uuidUser: String, _ username: String) -> Void)) {
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + "roadmaps/\(roadmapId)/userImage")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            
            do {
                let result = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    completion(result[1], result[0])
                }
                
            } catch { print(error) }
        }
        task.resume()
        
    }
    // MARK: - PUT
    func putRoadmap(roadmap: Roadmap, roadmapId: Int, newDays: [Day], selectedImage: UIImage? = nil) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let roadmapJson: [String: Any] = [
            "name": roadmap.name,
            "location": roadmap.location,
            "budget": roadmap.budget,
            "dayCount": roadmap.dayCount,
            "dateInitial": roadmap.dateInitial,
            "dateFinal": roadmap.dateFinal,
            "peopleCount": roadmap.peopleCount,
            "imageId": setupImage(category: roadmap.category),
            "category": roadmap.category,
            "isShared": roadmap.isShared,
            "isPublic": roadmap.isPublic,
            "shareKey": roadmap.shareKey,
            "createdAt": dateFormatter.string(from: Date()),
            "currency": roadmap.currency,
            "likesCount": roadmap.likesCount
        ]
        
        let session = URLSession.shared
        guard let url = URL(string: baseURL + "roadmaps/\(roadmapId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: roadmapJson, options: .prettyPrinted)
            } catch {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.postDays(roadmapId: roadmapId, daysCore: newDays)
                        if let selectedImage = selectedImage {
                            FirebaseManager.shared.uploadImageRoadmap(image: selectedImage, roadmapId: roadmapId, uuid: roadmap.imageId)
                        }
                        print("Atualizou")
                    }
                }
            }
            task.resume()
        }
    }
    
    func putImageRoadmap(roadmapId: Int, uuid: String) {
        let session = URLSession.shared
        var urlFinal = ""
        
        if roadmapId != 0 {
            urlFinal = "roadmaps/\(roadmapId)/\(uuid)"
        } else {
            if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
                let userID = String(data: data, encoding: .utf8)!
                print(userID)
                urlFinal = "users/\(userID)/\(uuid)"
            }
        }
        
        guard let url = URL(string: baseURL + urlFinal) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Atualizou imagem")
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - PUT
    func putBudgetRoadmap(roadmap: Roadmap, roadmapId: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let roadmapJson: [String: Any] = [
            "name": roadmap.name,
            "location": roadmap.location,
            "budget": roadmap.budget,
            "dayCount": roadmap.dayCount,
            "dateInitial": roadmap.dateInitial,
            "dateFinal": roadmap.dateFinal,
            "peopleCount": roadmap.peopleCount,
            "imageId": setupImage(category: roadmap.category ?? "defaultImage"),
            "category": roadmap.category,
            "isShared": roadmap.isShared,
            "isPublic": roadmap.isPublic,
            "shareKey": "ABC123",
            "createdAt": dateFormatter.string(from: Date()),
            "currency": roadmap.currency,
            "likesCount": roadmap.likesCount
        ]
        
        let session = URLSession.shared
        guard let url = URL(string: baseURL + "roadmaps/\(roadmapId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: roadmapJson, options: .prettyPrinted)
            } catch {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("Bugget atualizado")
                    }
                }
            }
            task.resume()
        }
    }

    // MARK: - JOIN
    func joinRoadmap(roadmapKey: String) {
        let session = URLSession.shared
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            guard let url = URL(string: baseURL + "roadmaps/\(roadmapKey)/users/\(userID)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            if let token = UserDefaults.standard.string(forKey: "authorization") {
                request.setValue(token, forHTTPHeaderField: "Authorization")
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = session.dataTask(with: request) { data, response, error in
                    print(response ?? "sem resposta")
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            do {
                                let roadmapJoin = try JSONDecoder().decode(Roadmap.self, from: data)
                                var newRoadmap = RoadmapRepository.shared.createRoadmap(roadmap: roadmapJoin, isNew: false)
                                newRoadmap.id = roadmapJoin.id
                                newRoadmap.shareKey = roadmapJoin.shareKey
                                newRoadmap.isShared = true
                                
                                var days = newRoadmap.days
                                var roadmapDays = roadmapJoin.days
                                days.sort { $0.id < $1.id }
                                roadmapDays.sort { $0.id < $1.id }
                                
                                for index in 0..<roadmapDays.count {
                                    days[index].id = roadmapDays[index].id
                                    let activiyArray = roadmapDays[index].activity
                                    for activity in activiyArray {
                                        _ = ActivityRepository.shared.createActivity(day: days[index], activity: activity, isNew: false)
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
