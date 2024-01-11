//
//  ActivityLocal+CoreDataClass.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

class ActivityRepository {
    static let shared: ActivityRepository = ActivityRepository()
    
    func createActivity(day: Day, activity: Activity, isNew: Bool)  {
        if isNew {
            DataManager.shared.postActivity(activity: activity, dayId: Int(day.id), activityCore: newActivity)
        }
    }
    
    func copyActivity(day: Day, activity: Activity) {
       
    }
    
    func updateActivity(day: Day, oldActivity: Activity, activity: Activity) {
        var newActivity = activity
        newActivity.id = oldActivity.id
        
        if newActivity.category.isEmpty { newActivity.category = oldActivity.category }
        
        DataManager.shared.putActivity(activity: newActivity, dayId: Int(day.id))
    }
    
    func deleteActivity(activity: Activity) throws {
        DataManager.shared.deleteObjectBack(objectID: Int(activity.id), urlPrefix: "activities")
    }
}
