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
    func updateRoadmap(editRoadmap: RoadmapLocal, roadmap: Roadmaps) {
        if editRoadmap.dayCount < roadmap.dayCount {
            let dif = Int(editRoadmap.dayCount) - roadmap.dayCount
            for index in stride(from: 0, to: dif, by: 1) {
                let newDay = DayRepository.shared.createDay(roadmap: editRoadmap, day: setupDays(startDay: roadmap.dateFinal, indexPath: index, isSelected: false))
            }
        }
        if editRoadmap.dayCount > roadmap.dayCount {
            if var newDays = editRoadmap.day?.allObjects as? [DayLocal] {
                newDays.sort { $0.id < $1.id }
                let dif = roadmap.dayCount - Int(editRoadmap.dayCount)
                for index in stride(from: 0, to: dif, by: 1) {
                    guard let newDay = try? DayRepository.shared.deleteDay(day: newDays[index]) else { return }
                }
            }
        }
        editRoadmap.name = roadmap.name
        editRoadmap.location = roadmap.location
        editRoadmap.dayCount = Int32(roadmap.dayCount)
        editRoadmap.peopleCount = Int32(roadmap.peopleCount)
        editRoadmap.imageId = roadmap.imageId
        editRoadmap.category = roadmap.category
        editRoadmap.isShared = roadmap.isShared
        editRoadmap.isPublic = roadmap.isPublic
        editRoadmap.shareKey = roadmap.shareKey
        editRoadmap.createdAt = roadmap.createdAt
        editRoadmap.date = roadmap.dateInitial
        self.saveContext()
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
