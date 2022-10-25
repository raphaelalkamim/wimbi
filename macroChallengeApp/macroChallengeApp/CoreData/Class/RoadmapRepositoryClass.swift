//
//  RoadmapLocal+CoreDataClass.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

public class RoadmapRepository: NSManagedObject {
    static let shared: RoadmapRepository = RoadmapRepository()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "macroChallengeApp")
        container.loadPersistentStores { _, error in
            if let erro = error {
                preconditionFailure(erro.localizedDescription)
            }
            
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
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
    
    func createRoadmap(roadmap: Roadmaps, isNew: Bool) -> RoadmapLocal {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        dateFormat.dateFormat = "dd/MM/yyyy"
        
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        newRoadmap.name = roadmap.name
        newRoadmap.location = roadmap.location
        newRoadmap.budget = roadmap.budget
        newRoadmap.dayCount = Int32(roadmap.dayCount)
        newRoadmap.peopleCount = Int32(roadmap.peopleCount)
        newRoadmap.imageId = roadmap.imageId
        newRoadmap.category = roadmap.category
        newRoadmap.isShared = roadmap.isShared
        newRoadmap.isPublic = roadmap.isPublic
        newRoadmap.shareKey = roadmap.shareKey
        newRoadmap.currency = roadmap.currency
        let dateInitial = dateFormat.date(from: roadmap.dateInitial)
        let dateFinal = dateFormat.date(from: roadmap.dateFinal)
        newRoadmap.date = dateInitial
        newRoadmap.dateFinal = dateFinal
        newRoadmap.createdAt = roadmap.createdAt
        // newRoadmap.addToUser(user)
        
        // save days in Roadmap
        var isFirstDay = false
        for index in 0..<roadmap.dayCount {
            if index == 0 {
                isFirstDay = true
            } else {
                isFirstDay = false
            }
            
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .short
            dateFormat.timeStyle = .none
            dateFormat.dateFormat = "dd/MM/yyyy"
            
            let date = dateFormat.date(from: roadmap.dateInitial)
            let newDay = DayRepository.shared.createDay(roadmap: newRoadmap, day: setupDays(startDay: date ?? Date(), indexPath: index, isSelected: isFirstDay))
        }
        
        if isNew {
            if var createdDays = newRoadmap.day?.allObjects as? [DayLocal] {
                createdDays.sort { $0.id < $1.id }
                self.postInBackend(newRoadmap: newRoadmap, roadmap: roadmap, newDays: createdDays)
            }
        }
        
        self.saveContext()
        return newRoadmap
    }
    func updateRoadmap(editRoadmap: RoadmapLocal, roadmap: Roadmaps, isShared: Bool) -> RoadmapLocal {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        dateFormat.dateFormat = "dd/MM/yyyy"
        
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        // guarda os dias antigos
        if var oldDays = editRoadmap.day?.allObjects as? [DayLocal] {
            oldDays.sort { $0.id < $1.id }
            
            // adiciona os novos dias no roteiro
            for index in 0..<roadmap.dayCount {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "d/M/y"
                _ = DayRepository.shared.createDay(roadmap: newRoadmap, day: setupDays(startDay: dateFormat.date(from: roadmap.dateInitial) ?? Date(), indexPath: Int(index), isSelected: false))
            }
            
            var range = roadmap.dayCount
            if roadmap.dayCount > oldDays.count {
                range = oldDays.count
            }
            // atualiza as atividades dos novos dia
            if var newDays = newRoadmap.day?.allObjects as? [DayLocal] {
                newDays.sort { $0.id < $1.id }
                newDays[0].isSelected = true
                for index in 0..<range {
                    // pegando atividades dos dias antigos
                    if var oldActivities = oldDays[index].activity?.allObjects as? [ActivityLocal] {
                        
                        oldActivities.sort { $0.hour ?? "1" < $1.hour ?? "2" }
                        // criando as atividades nos novos dias
                        for newActivity in 0..<oldActivities.count {
                            ActivityRepository.shared.copyActivity(day: newDays[index], activity: oldActivities[newActivity])
                        }
                    }
                }
            }
        }
        // cria o novo roadmap
        newRoadmap.id = editRoadmap.id
        newRoadmap.name = roadmap.name
        newRoadmap.location = roadmap.location
        newRoadmap.dayCount = Int32(roadmap.dayCount)
        newRoadmap.peopleCount = Int32(roadmap.peopleCount)
        newRoadmap.imageId = roadmap.imageId
        newRoadmap.category = roadmap.category
        newRoadmap.isShared = roadmap.isShared
        newRoadmap.isPublic = roadmap.isPublic
        newRoadmap.shareKey = roadmap.shareKey
        newRoadmap.date = dateFormat.date(from: roadmap.dateInitial)
        newRoadmap.dateFinal = dateFormat.date(from: roadmap.dateFinal)
        newRoadmap.budget = roadmap.budget
        newRoadmap.createdAt = roadmap.createdAt
        
        do {
            try self.deleteOldRoadmap(roadmap: editRoadmap)
        } catch {
            print("erro")
        }
        if var newDaysCore = newRoadmap.day?.allObjects as? [DayLocal] {
            newDaysCore.sort { $0.id < $1.id }
            if !isShared {
                self.updateBackend(roadmap: roadmap, id: Int(newRoadmap.id), newDaysCore: newDaysCore)
            }
        }
        
        self.saveContext()
        return newRoadmap
    }
    
    func updateFromBackend(editRoadmap: RoadmapLocal, roadmap: Roadmaps) -> RoadmapLocal {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        dateFormat.dateFormat = "dd/MM/yyyy"
        
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        // guarda os dias antigos
        var oldDays = roadmap.days
        oldDays.sort { $0.id < $1.id }
        
        // adiciona os novos dias no roteiro
        for index in 0..<roadmap.dayCount {
            print(index)
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "d/M/y"
            let day = DayRepository.shared.createDay(roadmap: newRoadmap, day: setupDays(startDay: dateFormat.date(from: roadmap.dateInitial) ?? Date(), indexPath: Int(index), isSelected: false))
            day.id = Int32(oldDays[index].id)
        }
        
        var range = roadmap.dayCount

        // atualiza as atividades dos novos dia
        if var newDays = newRoadmap.day?.allObjects as? [DayLocal] {
            newDays.sort { $0.id < $1.id }
            newDays[0].isSelected = true
            for index in 0..<range {
                // pegando atividades dos dias antigos
                var oldActivities = oldDays[index].activity
                
                oldActivities.sort { $0.hour < $1.hour }
                // criando as atividades nos novos dias
                for newActivity in 0..<oldActivities.count {
                    let activity = ActivityRepository.shared.createActivity(day: newDays[index], activity: oldActivities[newActivity], isNew: false)
                    activity.id = Int32(oldActivities[newActivity].id)
                }
            }
        }
        // cria o novo roadmap
        newRoadmap.id = Int32(roadmap.id)
        newRoadmap.name = roadmap.name
        newRoadmap.location = roadmap.location
        newRoadmap.dayCount = Int32(roadmap.dayCount)
        newRoadmap.peopleCount = Int32(roadmap.peopleCount)
        newRoadmap.imageId = roadmap.imageId
        newRoadmap.category = roadmap.category
        newRoadmap.isShared = roadmap.isShared
        newRoadmap.isPublic = roadmap.isPublic
        newRoadmap.shareKey = roadmap.shareKey
        newRoadmap.date = dateFormat.date(from: roadmap.dateInitial)
        newRoadmap.dateFinal = dateFormat.date(from: roadmap.dateFinal)
        newRoadmap.budget = roadmap.budget
        newRoadmap.createdAt = roadmap.createdAt
        
        do {
            try self.deleteOldRoadmap(roadmap: editRoadmap)
        } catch {
            print("erro")
        }
        if var newDaysCore = newRoadmap.day?.allObjects as? [DayLocal] {
            newDaysCore.sort { $0.id < $1.id }
        }
        
        self.saveContext()
        return newRoadmap
    }
    
    func setupDays(startDay: Date, indexPath: Int, isSelected: Bool) -> Day {
        let date = startDay.addingTimeInterval(Double(indexPath) * 24 * 3600)
        var day = Day(isSelected: isSelected, date: date)
        day.id = indexPath
        return day
    }
    
    func getRoadmap() -> [RoadmapLocal] {
        let fetchRequest = NSFetchRequest<RoadmapLocal>(entityName: "RoadmapLocal")
        do {
            return try self.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return []
    }
    
    func deleteRoadmap(roadmap: RoadmapLocal) throws {
        DataManager.shared.deleteObjectBack(objectID: Int(roadmap.id), urlPrefix: "roadmaps", {
            print("deleted roadmap")
        })
        self.persistentContainer.viewContext.delete(roadmap)
        self.saveContext()
    }
    
    func deleteOldRoadmap(roadmap: RoadmapLocal) throws {
        self.persistentContainer.viewContext.delete(roadmap)
        self.saveContext()
    }
    
    func postInBackend(newRoadmap: RoadmapLocal, roadmap: Roadmaps, newDays: [DayLocal]) {
        DataManager.shared.postRoadmap(roadmap: roadmap, roadmapCore: newRoadmap, daysCore: newDays)
    }
    
    func updateBackend(roadmap: Roadmaps, id: Int, newDaysCore: [DayLocal]) {
        DataManager.shared.putRoadmap(roadmap: roadmap, roadmapId: id, newDaysCore: newDaysCore)
    }
}
