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
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Problema de contexto: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createActivity(day: DayLocal, activity: ActivityLocal) -> ActivityLocal {
        guard let newActivity = NSEntityDescription.insertNewObject(forEntityName: "ActivityLocal", into: context) as? ActivityLocal else { preconditionFailure() }
        
        newActivity.id = Int32(activity.id)
        newActivity.name = activity.name
        newActivity.category = activity.category
        newActivity.location = activity.location
        newActivity.hour = activity.hour
        newActivity.budget = activity.budget
        
        day.addToActivity(newActivity)
        
        self.saveContext()
        return newActivity
    }
    
    func getActivity() -> [ActivityLocal] {
        let fr = NSFetchRequest<ActivityLocal>(entityName: "ActivityLocal")
        do {
            return try self.persistentContainer.viewContext.fetch(fr)
        } catch {
            print(error)
        }
        return []
    }
    
    func deleteActivity(activity: ActivityLocal) throws {
        self.persistentContainer.viewContext.delete(activity)
        self.saveContext()
    }
}
