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
    
    func createRoadmap(roadmap: Roadmaps) -> RoadmapLocal {
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        
        newRoadmap.id = Int32(roadmap.id)
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
        newRoadmap.createdAt = roadmap.createdAt
        newRoadmap.date = roadmap.dateInitial
        // newRoadmap.addToUser(user)
        self.saveContext()
        return newRoadmap
    }
    func updateRoadmap(editRoadmap: RoadmapLocal, roadmap: Roadmaps) -> RoadmapLocal {
        guard let newRoadmap = NSEntityDescription.insertNewObject(forEntityName: "RoadmapLocal", into: context) as? RoadmapLocal else { preconditionFailure() }
        // guarda os dias antigos
        if var oldDays = editRoadmap.day?.allObjects as? [DayLocal] {
            oldDays.sort { $0.id < $1.id }
            
            // adiciona os novos dias no roteiro
            var isFirstDay = false
            for index in 0..<editRoadmap.dayCount {
                if index == 0 {
                    isFirstDay = true
                } else {
                    isFirstDay = false
                }
                _ = DayRepository.shared.createDay(roadmap: newRoadmap, day: setupDays(startDay: roadmap.dateInitial, indexPath: Int(index), isSelected: isFirstDay))
            }
            
            // atualiza as atividades dos novos dia
            if var newDays = newRoadmap.day?.allObjects as? [DayLocal] {
                newDays.sort { $0.id < $1.id }
                for index in 0..<oldDays.count {
                    // pegando atividades dos dias antigos
                    if var oldActivities = oldDays[index].activity?.allObjects as? [ActivityLocal] {
                        oldActivities.sort { $0.hour ?? "1" < $1.hour ?? "2" }
                        // criando as atividades nos novos dias
                        for activity in oldActivities {
                            ActivityRepository.shared.copyActivity(day: newDays[index], activity: activity)
                        }
                    }
                }
            }
            
        }
        
        // cria os novos dias
        newRoadmap.name = roadmap.name
        newRoadmap.location = roadmap.location
        newRoadmap.dayCount = Int32(roadmap.dayCount)
        newRoadmap.peopleCount = Int32(roadmap.peopleCount)
        newRoadmap.imageId = roadmap.imageId
        newRoadmap.category = roadmap.category
        newRoadmap.isShared = roadmap.isShared
        newRoadmap.isPublic = roadmap.isPublic
        newRoadmap.shareKey = roadmap.shareKey
        newRoadmap.createdAt = roadmap.createdAt
        newRoadmap.date = roadmap.dateInitial
        
        do {
            try self.deleteRoadmap(roadmap: editRoadmap)
        } catch {
            print("erro")
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
        self.persistentContainer.viewContext.delete(roadmap)
        self.saveContext()
    }
    
}
