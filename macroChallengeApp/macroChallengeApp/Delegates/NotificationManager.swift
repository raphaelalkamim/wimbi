//
//  NotificationManager.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 05/10/22.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    let center = UNUserNotificationCenter.current()
    var roadmaps = RoadmapRepository.shared.getRoadmap()
    var roadmap: RoadmapLocal = RoadmapLocal()
    var days: [DayLocal] = []
    var activities: [ActivityLocal] = []
    var daySelected = 0
    
    override init() {
        super.init()
        center.delegate = self
    }
    
    @objc func registerLocalNotifications() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    func registerCategories() {
        let show = UNNotificationAction(identifier: "show", title: "Vamos lá!".localized(), options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func changeNotificationStatus(isEnabled: Bool) {
        if UserDefaults.standard.bool(forKey: "switch") != true {
            print("registrou")
            registerNotification(identifier: "alarm")
        } else {
            self.center.removeAllPendingNotificationRequests()
            print("removeu")
            
        }
    }
    @objc func createLocalNotification(hour: Int, min: Int) {
        registerCategories()
        
        let content = UNMutableNotificationContent()
        content.title = "Tá chegando"
        content.body = "Sua atividade é daqui tantos mins"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = min
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                
            default:
                break
            }
        }
        completionHandler()
    }
    
    func registerNotification(identifier: String) {
        roadmaps.sort {
            $0.date ?? Date() < $1.date ?? Date()
        }
        roadmap = roadmaps[0]
        getAllDays()
        for day in days {
            self.activities = getAllActivities(day: day)
            for activity in activities {
//                createLocalNotification(hour: activity.hour, min: 36)
            }
        }
        
    }
    
    // MARK: Data collection
    func getAllDays() {
        if var newDays = roadmap.day?.allObjects as? [DayLocal] {
            newDays.sort { $0.id < $1.id }
            self.days = newDays
        }
        for index in 0..<days.count where days[index].isSelected == true {
            self.daySelected = index
        }
    }
    
    func getAllActivities(day: DayLocal) -> [ActivityLocal] {
        if var newActivities = day.activity?.allObjects as? [ActivityLocal] {
            newActivities.sort { $0.hour ?? "1" < $1.hour ?? "2" }
            return newActivities
        }
        return []
    }
}
