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
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        
        // add infos in Roadmap
        self.setRoadmapData(fromRoadmap: roadmap, toRoadmap: newRoadmap)
        // save days in Roadmap
        self.createDaysInRoadmap(fromRoadmap: roadmap, toRoadmap: newRoadmap)
        
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
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        
        // cria o novo roadmap
        self.setRoadmapData(fromRoadmap: roadmap, toRoadmap: newRoadmap)
        
        newRoadmap.id = editRoadmap.id
        // guarda os dias antigos
        if var oldDays = editRoadmap.day?.allObjects as? [DayLocal] {
            oldDays.sort { $0.id < $1.id }
            
            // adiciona os novos dias no roteiro
            for index in 0..<roadmap.dayCount {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd/MM/yyyy"
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
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        
        // cria o novo roadmap
        self.setRoadmapData(fromRoadmap: roadmap, toRoadmap: newRoadmap)
        newRoadmap.id = Int32(roadmap.id)
        
        // guarda os dias antigos
        var oldDays = roadmap.days
        oldDays.sort { $0.id < $1.id }
        
        // adiciona os novos dias no roteiro
        for index in 0..<roadmap.dayCount {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let day = DayRepository.shared.createDay(roadmap: newRoadmap, day: setupDays(startDay: dateFormat.date(from: roadmap.dateInitial) ?? Date(), indexPath: Int(index), isSelected: false))
            day.id = Int32(oldDays[index].id)
        }
        
        let range = roadmap.dayCount
        
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
        
        do {
            try self.deleteOldRoadmap(roadmap: editRoadmap)
        } catch {
            print("erro")
        }
        
        self.saveContext()
        return newRoadmap
    }
    
    func setRoadmapData(fromRoadmap: Roadmaps, toRoadmap: RoadmapLocal) {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        dateFormat.dateFormat = "dd/MM/yyyy"
        
        toRoadmap.name = fromRoadmap.name
        toRoadmap.location = fromRoadmap.location
        toRoadmap.budget = fromRoadmap.budget
        toRoadmap.dayCount = Int32(fromRoadmap.dayCount)
        toRoadmap.peopleCount = Int32(fromRoadmap.peopleCount)
        toRoadmap.imageId = fromRoadmap.imageId
        toRoadmap.category = fromRoadmap.category
        toRoadmap.isShared = fromRoadmap.isShared
        toRoadmap.isPublic = fromRoadmap.isPublic
        toRoadmap.shareKey = fromRoadmap.shareKey
        toRoadmap.currency = fromRoadmap.currency
        toRoadmap.date = dateFormat.date(from: fromRoadmap.dateInitial)
        toRoadmap.dateFinal = dateFormat.date(from: fromRoadmap.dateFinal)
        toRoadmap.createdAt = fromRoadmap.createdAt
    }
    
    func createDaysInRoadmap(fromRoadmap: Roadmaps,toRoadmap: RoadmapLocal) {
        var isFirstDay = false
        for index in 0..<fromRoadmap.dayCount {
            if index == 0 {
                isFirstDay = true
            } else {
                isFirstDay = false
            }
            
            let dateFormat = DateFormatter()
            dateFormat.dateStyle = .short
            dateFormat.timeStyle = .none
            dateFormat.dateFormat = "dd/MM/yyyy"
            
            let date = dateFormat.date(from: fromRoadmap.dateInitial)
            let newDay = DayRepository.shared.createDay(roadmap: toRoadmap, day: setupDays(startDay: date ?? Date(), indexPath: index, isSelected: isFirstDay))
        }
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
