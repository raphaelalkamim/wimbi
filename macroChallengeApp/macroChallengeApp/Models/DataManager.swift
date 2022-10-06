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
    var delegate: UserLoggedInDelegate?
    
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
    
    func postUser(username: String, usernameApp: String, name: String, photoId: String, password: String, _ completion: @escaping (() -> Void)) {
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
                        DispatchQueue.main.async {
                            completion()
                        }
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
                        
                        DispatchQueue.main.async {
                            self.delegate?.finishLogin()
                        }
                    }
                }
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
    }
    
    func postRoadmap(roadmap: Roadmaps, roadmapCore: RoadmapLocal) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let roadmap: [String: Any] = [
            "name": roadmap.name,
            "location": roadmap.location,
            "budget": 0,
            "dayCount": roadmap.dayCount,
            "dateInitial": roadmap.dateInitial,
            "dateFinal": roadmap.dateFinal,
            "peopleCount": roadmap.peopleCount,
            "imageId": roadmap.imageId,
            "category": roadmap.category,
            "isShared": roadmap.isShared,
            "isPublic": roadmap.isPublic,
            "shareKey": "ABC123",
            "createdAt": dateFormatter.string(from: Date())
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
                    print(response)
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            do {
                                // tentar transformar os dados no tipo Cohort
                                let roadmapResponse = try JSONDecoder().decode(RoadmapDTO.self, from: data)
                                #warning("FAZER CRIACAO DE DIA")
                                
                                self.postDays(roadmapId: roadmapResponse.id)
                                
                                roadmapCore.id = Int32(roadmapResponse.id)
                                RoadmapRepository.shared.saveContext()
                            } catch {
                                // FIXME: tratar o erro do decoder
                                print(error)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
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
                print(response)
                guard let data = data else { return }
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
                
                do {
                    // tentar transformar os dados no tipo Cohort
                    user = try JSONDecoder().decode(User.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(user!)
                    }
                } catch {
                    // FIXME: tratar o erro do decoder
                    print(error)
                }
            }
            task.resume()
            
        }
    }
    
    func getPublicRoadmaps(_ completion: @escaping ((_ roadmaps: [RoadmapDTO]) -> Void)) {
        var roadmaps: [RoadmapDTO] = []
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + "roadmaps")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            
            do {
                roadmaps = try JSONDecoder().decode([RoadmapDTO].self, from: data)
                
                DispatchQueue.main.async {
                    completion(roadmaps)
                }
            } catch {
                // FIXME: tratar o erro do decoder
                print("DEU RUIM NO PARSE")
            }
        }
        task.resume()
    }
    
    func putUser(userObj: User, _ completion: @escaping ((_ user: User) -> Void)) {
        let user: [String: Any] = [
            "usernameApp": userObj.usernameApp,
            "name": userObj.name,
            "photoId": userObj.photoId
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
                let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print(error)
                    } else if data != nil {
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 200 {
                                DispatchQueue.main.async {
                                    completion(userObj)
                                }
                            }
                        }
                    } else {
                        // Handle unexpected error
                    }
                }
                task.resume()
            }
        }
    }
    
    func getRoadmapById(roadmapId: Int, _ completion: @escaping ((_ roadmap: Roadmaps) -> Void)) {
        var roadmap: Roadmaps = Roadmaps()
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + "roadmaps/\(roadmapId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            
            do {
                roadmap = try JSONDecoder().decode(Roadmaps.self, from: data)
                DispatchQueue.main.async {
                    completion(roadmap)
                }
            } catch {
                // FIXME: tratar o erro do decoder
                print(error)
                print("DEU RUIM NO PARSE")
            }
        }
        task.resume()
        
    }
    
    func putRoadmap(roadmap: Roadmaps, roadmapId: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let roadmapJson: [String: Any] = [
            "name": roadmap.name,
            "location": roadmap.location,
            "budget": 0,
            "dayCount": roadmap.dayCount,
            "dateInitial": roadmap.dateInitial,
            "dateFinal": roadmap.dateFinal,
            "peopleCount": roadmap.peopleCount,
            "imageId": roadmap.imageId,
            "category": roadmap.category,
            "isShared": roadmap.isShared,
            "isPublic": roadmap.isPublic,
            "shareKey": "ABC123",
            "createdAt": dateFormatter.string(from: Date())
        ]
        
        let session = URLSession.shared
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
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
                    print(response)
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                           print("Atualizou")
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    func postDays(roadmapId: Int) {
        let session = URLSession.shared
            guard let url = URL(string: baseURL + "roadmaps/\(roadmapId)/days") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            if let token = UserDefaults.standard.string(forKey: "authorization") {
                request.setValue(token, forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let task = session.dataTask(with: request) { data, response, error in
                    print(response)
                    guard let data = data else { return }
                    if error != nil {
                        print(String(describing: error?.localizedDescription))
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("Crio DIAS")
                        }
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



struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
