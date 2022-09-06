//
//  DataManager.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 05/09/22.
//

import Foundation
import UIKit


class DataManager {
    public static var shared: DataManager = DataManager()
    let baseURL: String = "https://macroptrip-api.herokuapp.com/"
        
    public let imageCash = NSCache<NSNumber, UIImage>()
    
    var roadmaps: Roadmaps?
    var user: User?
    var activity: Activity?
    var day: Day?
    var like: Like?
    
    // MARK: - Load Data
    public func loadData(_ completion: @escaping (()->Void), dataURL: String, dataType: DataType) {
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: baseURL + dataURL)!
        
        // resposta vem no data (json), error vem no error
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {return}
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
            self.getDataType(dataType: dataType, data: data)
        }
        task.resume()
    }
    
    private func getDataType(dataType: DataType, data: Data ) {
        switch dataType {
        case .User:
            do {
                self.user =  try JSONDecoder().decode(User.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .Roadmaps:
            do {
                self.roadmaps =  try JSONDecoder().decode(Roadmaps.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .Activity:
            do {
                self.activity =  try JSONDecoder().decode(Activity.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .Day:
            do {
                self.day =  try JSONDecoder().decode(Day.self, from: data)
            } catch {
                print("Parse Error")
            }
        case .Like:
            do {
                self.like = try JSONDecoder().decode(Like.self, from: data)
            } catch {
                print("Parse Error")
            }
        }
    }
    #warning("Corrigir essa funcao para utilizar no codigo")
    func decodeType<T: Codable>(_ class: T, data: Data) -> T? {
        do {
            let newData  = try JSONDecoder().decode(T.self, from: data)
            return newData
        } catch {
            print("Parse Error")
        }
        return nil
    }
}
