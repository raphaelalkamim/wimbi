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
    
    func postRoadmap(roadmap: Roadmaps, roadmapCore: RoadmapLocal, daysCore: [DayLocal]) {
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
            "imageId": setupImage(category: roadmap.category),
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
                                
                                self.postDays(roadmapId: roadmapResponse.id, daysCore: daysCore)
                                
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
        
        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data else { return }
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
    
    func putRoadmap(roadmap: Roadmaps, roadmapId: Int, newDaysCore: [DayLocal]) {
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
                            self.postDays(roadmapId: roadmapId, daysCore: newDaysCore)
                            print("Atualizou")
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    func postDays(roadmapId: Int, daysCore: [DayLocal]) {
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
                        do {
                            // tentar transformar os dados no tipo Cohort
                            var daysResponse = try JSONDecoder().decode([DayDTO].self, from: data)
                            
                            daysResponse.sort { $0.id < $1.id }
                            
                            for index in 0..<daysResponse.count {
                                daysCore[index].id = Int32(daysResponse[index].id)
                                DayRepository.shared.saveContext()
                            }
                            
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
    
    func postActivity(activity: Activity, dayId: Int, activityCore: ActivityLocal) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let activity: [String: Any] = [
            "name": activity.name,
            "category": activity.category,
            "location": activity.location,
            "hour": activity.hour,
            "budget": activity.budget
        ]
        
        let session = URLSession.shared
        guard let url = URL(string: baseURL + "days/\(dayId)/activities") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: activity, options: .prettyPrinted)
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
                            let activityResponse = try JSONDecoder().decode(Activity.self, from: data)
                            
                            activityCore.id = Int32(activityResponse.id)
                            ActivityRepository.shared.saveContext()
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
    
    func putActivity(activity: Activity, dayId: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let activityNew: [String: Any] = [
            "name": activity.name,
            "category": activity.category,
            "location": activity.location,
            "hour": activity.hour,
            "budget": activity.budget
        ]
        
        let session = URLSession.shared
        
        guard let url = URL(string: baseURL + "days/\(dayId)/activities/\(activity.id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: activityNew, options: .prettyPrinted)
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
    
    func deleteObjectBack(objectID: Int, urlPrefix: String, _ completion: @escaping (() -> Void)) {
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + "\(urlPrefix)/\(objectID)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            completion()
                        }
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
    
    func setupImage(category: String) -> String {
        if category == "Beach".localized() {
            let beachImages = ["beach0", "beach1", "beach2", "beach3", "beach4"]
            return beachImages[Int.random(in: 0..<beachImages.count)]
        } else if category == "Mountain".localized() {
            let mountainImages = ["montain0", "montain1", "montain2", "montain3", "montain4"]
            return mountainImages[Int.random(in: 0..<mountainImages.count)]
        } else if category == "City".localized() {
            let cityImages = ["city0", "city1", "city2", "city3"]
            return cityImages[Int.random(in: 0..<cityImages.count)]
        } else {
            let campImages = ["camp0", "camp1", "camp2", "camp3", "camp4"]
            return campImages[Int.random(in: 0..<campImages.count)]
        }
    }
}

struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
