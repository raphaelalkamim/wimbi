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
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "macroChallengeApp")
        container.loadPersistentStores { _, error in
            if let erro = error {
                preconditionFailure(erro.localizedDescription)
            }
            
        }
        return container
    }()
    
    var context = RoadmapRepository.shared.context
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Problema de contexto: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createActivity(day: DayLocal, activity: Activity, isNew: Bool) -> ActivityLocal {
        guard let newActivity = NSEntityDescription.insertNewObject(forEntityName: "ActivityLocal", into: context) as? ActivityLocal else { preconditionFailure() }
        newActivity.id = Int32(activity.id)
        self.setActivityData(fromActivity: activity, toActivity: newActivity)
        
        if isNew {
            DataManager.shared.postActivity(activity: activity, dayId: Int(day.id), activityCore: newActivity)
        }
        
        day.addToActivity(newActivity)
        self.saveContext()
        return newActivity
    }
    func copyActivity(day: DayLocal, activity: ActivityLocal) {
        guard let newActivity = NSEntityDescription.insertNewObject(forEntityName: "ActivityLocal", into: context) as? ActivityLocal else { preconditionFailure() }
        
        newActivity.id = activity.id
        newActivity.name = activity.name
        newActivity.category = activity.category
        newActivity.location = activity.location
        newActivity.hour = activity.hour
        newActivity.budget = activity.budget
        newActivity.currencyType = activity.currencyType
        newActivity.tips = activity.tips
        newActivity.address = activity.address
        newActivity.link = activity.link
        
        day.addToActivity(newActivity)
        
        self.saveContext()
    }
    func updateActivity(day: DayLocal, oldActivity: ActivityLocal, activity: Activity) {
        oldActivity.id = Int32(activity.id)
        self.setActivityData(fromActivity: activity, toActivity: oldActivity)
        if activity.category.isEmpty { oldActivity.category = oldActivity.category }
        
        DataManager.shared.putActivity(activity: activity, dayId: Int(day.id))
        
        self.saveContext()
    }
    
    func setActivityData(fromActivity: Activity, toActivity: ActivityLocal) {
        toActivity.name = fromActivity.name
        toActivity.category = fromActivity.category
        toActivity.location = fromActivity.location
        toActivity.hour = fromActivity.hour
        toActivity.budget = fromActivity.budget
        toActivity.currencyType = fromActivity.currency
        toActivity.tips = fromActivity.tips
        toActivity.address = fromActivity.address
        toActivity.link = fromActivity.link
    }
    func updateActivityDay(roadmap: RoadmapLocal, oldDay: DayLocal, activityLocal: ActivityLocal, newActivity: Activity) {
        if activityLocal.day?.date != newActivity.day?.date {
            // chama os dias do roadmap
            guard let allDays = roadmap.day?.allObjects as? [DayLocal] else { return }
            for day in allDays where day.date == newActivity.day?.date {
                    // adiciona a atividade no dia encontrado no coreData
                _ = self.createActivity(day: day, activity: newActivity, isNew: true)
            }
            // deleta a atividade do dia antigo
            do {
                try self.deleteActivity(activity: activityLocal)
            } catch {
                print("Erro ao deletar")
            }
        }
    }
    func getActivity() -> [ActivityLocal] {
        let fetchRequest = NSFetchRequest<ActivityLocal>(entityName: "ActivityLocal")
        do {
            return try self.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return []
    }
    
    func deleteActivity(activity: ActivityLocal) throws {
        DataManager.shared.deleteObjectBack(objectID: Int(activity.id), urlPrefix: "activities")
        
        context.delete(activity)
        saveContext()
    }
}
