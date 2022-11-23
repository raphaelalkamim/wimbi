//
//  +Activity.swift
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
    func postActivity(activity: Activity, dayId: Int, activityCore: ActivityLocal) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let activity: [String: Any] = [
            "name": activity.name,
            "tips": activity.tips,
            "category": activity.category,
            "location": activity.location,
            "hour": activity.hour,
            "budget": activity.budget,
            "currency": activity.currency,
            "address": activity.address,
            "link": activity.link
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
                            print(error)
                        }
                    }
                    
                }
            }
            task.resume()
        }
    }
    // MARK: - PUT
    func putActivity(activity: Activity, dayId: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/y"
        
        let activityNew: [String: Any] = [
            "name": activity.name,
            "tips": activity.tips,
            "category": activity.category,
            "location": activity.location,
            "hour": activity.hour,
            "budget": activity.budget,
            "currency": activity.currency,
            "address": activity.address,
            "link": activity.link
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
                guard let data = data else { return }
                if error != nil {
                    print(String(describing: error?.localizedDescription))
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
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
