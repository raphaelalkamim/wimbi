//
//  DayLocal+CoreDataClass.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

class DayRepository: NSManagedObject {
    static let shared: DayRepository = DayRepository()
    
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
    
    func createDay(roadmap: RoadmapLocal, day: Day) -> DayLocal {
        guard let newDay = NSEntityDescription.insertNewObject(forEntityName: "DayLocal", into: context) as? DayLocal else { preconditionFailure() }
        
        newDay.id = Int32(day.id)
        newDay.date = day.date
        newDay.isSelected = day.isSelected
        
        roadmap.addToDay(newDay)
        
        self.saveContext()
        return newDay
    }
    
    func getDay() -> [DayLocal] {
        let fetchRequest = NSFetchRequest<DayLocal>(entityName: "DayLocal")
        do {
            return try self.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return []
    }
    
    func deleteDay(day: DayLocal) throws {
        self.persistentContainer.viewContext.delete(day)
        self.saveContext()
    }
    
}
