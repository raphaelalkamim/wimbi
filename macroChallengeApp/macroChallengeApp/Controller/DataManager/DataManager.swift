//
//  DataManager.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAnalytics

class DataManager {
    public static var shared = DataManager()
    
    #warning("Para testar o app, use a url de dev! Para subir o App, use a url da API")
    //let baseURL: String = "https://macrotrip-dev.herokuapp.com/"
    let baseURL: String = "https://macroptrip-api.herokuapp.com/"
    
    public let imageCash = NSCache<NSNumber, UIImage>()
    
    var roadmaps: Roadmap?
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
                self.roadmaps = try JSONDecoder().decode(Roadmap.self, from: data)
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
    func deleteObjectBack(objectID: Int = 0, username: String = "", urlPrefix: String) {
        let session: URLSession = URLSession.shared
        var url: URL
        if username.isEmpty {
            url = URL(string: baseURL + "\(urlPrefix)/\(objectID)")!
        } else {
            url = URL(string: baseURL + "\(urlPrefix)/\(username)")!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = UserDefaults.standard.string(forKey: "authorization") {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request) { data, _, error in
                guard data != nil else { return }
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
            }
            task.resume()
        }
    }
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
        return String("\(category)Cover")
    }
}

struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
