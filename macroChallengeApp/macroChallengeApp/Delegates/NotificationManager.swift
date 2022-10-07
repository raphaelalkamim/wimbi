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
    var notificationPhrases = ["wimbi", "Bom dia!", "Boa tarde!", "Boa noite!", "Olá, explorador!"]
    
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
        let show = UNNotificationAction(identifier: "show", title: "Vamos lá!", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func changeNotificationStatus(isEnabled: Bool) {
        if UserDefaults.standard.bool(forKey: "switch") != true {
            print("registrou")
            //            registerNotification()
        } else {
            self.center.removeAllPendingNotificationRequests()
            print("removeu")
            
        }
    }
    @objc func createActivityNotification(hour: Int, min: Int, day: Int, month: Int, year: Int, activityName: String, number: Int, interval: Int) {
        registerCategories()
        let content = UNMutableNotificationContent()
        var intervalType: String = ""
        
        if interval == 1 {
            if number == 1 {
                intervalType = "minuto"
            } else {
                intervalType = "minutos"
            }
        } else if interval == 2 {
            if number == 1 {
                intervalType = "hora"
            } else {
                intervalType = "horas"
            }
        } else {
            if number == 1 {
                intervalType = "dia"
            } else {
                intervalType = "dias"
            }
        }
        
        content.title = "wimbi"
        content.body = "A atividade \(activityName) começa em \(number) \(intervalType)."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        if interval == 1 { // minuto
            dateComponents.minute = min - number
            dateComponents.hour = hour
            dateComponents.day = day
            
        } else if interval == 2 { // hora
            dateComponents.hour = hour - number
            dateComponents.minute = min
            dateComponents.day = day
        } else { // dia
            dateComponents.day = day - number
            dateComponents.hour = hour
            dateComponents.minute = min
        }
        dateComponents.year = year + 2000
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        print(request)
        center.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
        
    @objc func createTripNotification(day: Int, month: Int, year: Int, tripName: String) {
        registerCategories()
        let content = UNMutableNotificationContent()
        
        content.title = "wimbi"
        content.body = "Sua viagem para \(tripName) começa agora!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 27
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.year = year + 2000
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        print(request)
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
    
    func registerActivityNotification(createdActivity: ActivityLocal) {
        let delimiter = ":"
        let hour = createdActivity.hour?.components(separatedBy: delimiter)
        
        let delimiterDay = "/"
        let date = createdActivity.day?.date?.components(separatedBy: delimiterDay)
        
        let activityHour = hour?[0] ?? "0"
        let activityMinute = hour?[1] ?? "0"
        let activityDay = date?[0] ?? "0"
        let activityMonth = date?[1] ?? "0"
        let activityYear = date?[2] ?? "0"
        
        createActivityNotification(hour: Int(activityHour) ?? 0,
                                   min: Int(activityMinute) ?? 0,
                                   day: Int(activityDay) ?? 0,
                                   month: Int(activityMonth) ?? 0,
                                   year: Int(activityYear) ?? 0,
                                   activityName: createdActivity.name ?? "Atividade",
                                   number: UserDefaults.standard.integer(forKey: "number") + 1,
                                   interval: UserDefaults.standard.integer(forKey: "interval") + 1)
    }
    
    func registerTripNotification(roadmap: RoadmapLocal) {
        let delimiter = "/"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let newDate = dateFormatter.string(from: roadmap.date ?? Date())
        let new = newDate.components(separatedBy: delimiter)
        
        let roadmapDay = new[0]
        let roadmapMonth = new[1]
        let roadmapYear = new[2]
        
        createTripNotification(day: Int(String(roadmapDay))!,
                               month: Int(String(roadmapMonth)) ?? 0,
                               year: Int(String(roadmapYear)) ?? 0,
                               tripName: roadmap.name ?? "Destino")
        
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
