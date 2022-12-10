//
//  +Days.swift
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
                guard let data = data else { return }
                if error != nil { print(String(describing: error?.localizedDescription)) }
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
                            
                            for day in daysCore {
                                if var oldActivities = day.activity?.allObjects as? [ActivityLocal] {
                                    for activity in oldActivities {
                                        self.postActivityUpdated(dayId: Int(day.id), activityCore: activity)
                                    }
                                }
                            }
                            
                        } catch { print(error) }
                    }
                }
            }
            task.resume()
        }
    }
}
