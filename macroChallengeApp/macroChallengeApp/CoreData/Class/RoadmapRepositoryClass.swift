//
//  RoadmapLocal+CoreDataClass.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData
import UIKit

public class RoadmapRepository: NSManagedObject {
    static let shared: RoadmapRepository = RoadmapRepository()
        
    // MARK: Manage Data Cloud
    func getDataCloud() -> [Roadmap] {
        var roadmaps: [Roadmap]?
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            DataManager.shared.getUser(username: userID, { user in
                if UserRepository.shared.getUser().isEmpty {
                    let userLocal = UserRepository.shared.createUser(user: user)
                }
                if !user.userRoadmap.isEmpty {
                    for roadmap in user.userRoadmap {
                        DataManager.shared.getRoadmapById(roadmapId: roadmap.id) { pushedRoadmap in
                            roadmaps?.append(pushedRoadmap ?? Roadmap())
                        }
                    }
                }
            })
        }
        return roadmaps ?? []
    }
    
    func createRoadmap(roadmap: Roadmap, isNew: Bool, selectedImage: UIImage? = nil) -> Roadmap {
        if isNew {
            var createdDays = roadmap.days
            createdDays.sort { $0.id < $1.id }
            self.postInBackend(roadmap: roadmap, newDays: createdDays, selectedImage: selectedImage)
            
        }
        return roadmap
    }
    
    func updateRoadmap(oldRoadmap: Roadmap, newRoadmap: Roadmap, isShared: Bool, selectedImage: UIImage? = nil) -> Roadmap {
        var roadmap = newRoadmap
        roadmap.id = oldRoadmap.id
        roadmap.shareKey = oldRoadmap.shareKey
         
        var newDays = newRoadmap.days
        newDays.sort { $0.id < $1.id }
        newDays[0].isSelected = true
        
        self.updateBackend(roadmap: roadmap, id: Int(newRoadmap.id), newDays: newDays, selectedImage: selectedImage)
        return newRoadmap
    }
    
    func pushRoadmap(newRoadmap: UserRoadmap) -> Roadmap? {
        DataManager.shared.getRoadmapById(roadmapId: Int(newRoadmap.roadmap.id)) { roadmap in
           // return roadmap
        }
        return Roadmap()
    }
    
    func setupDays(startDay: Date, indexPath: Int, isSelected: Bool) -> Day {
        let date = startDay.addingTimeInterval(Double(indexPath) * 24 * 3600)
        var day = Day(isSelected: isSelected, date: date)
        day.id = indexPath
        return day
    }
    
    func deleteRoadmap(roadmap: Roadmap) throws {
        FirebaseManager.shared.deleteImage(category: 0, uuid: roadmap.imageId)
        DataManager.shared.deleteObjectBack(objectID: Int(roadmap.id), urlPrefix: "roadmaps")
    }
    
    func updateRoadmapBudget(roadmap: Roadmap, budget: Double) {
        // atualiza localmente
        var newRoadmap = roadmap
        newRoadmap.id = roadmap.id
        newRoadmap.budget = budget
        DataManager.shared.putBudgetRoadmap(roadmap: newRoadmap, roadmapId: Int(roadmap.id))
    }
    
    func postInBackend(roadmap: Roadmap, newDays: [Day], selectedImage: UIImage? = nil) {
        DataManager.shared.postRoadmap(roadmap: roadmap, days: newDays, selectedImage: selectedImage)
    }
    
    func updateBackend(roadmap: Roadmap, id: Int, newDays: [Day], selectedImage: UIImage? = nil) {
        DataManager.shared.putRoadmap(roadmap: roadmap, roadmapId: id, newDays: newDays, selectedImage: selectedImage)
    }
}
