//
//  UserLocal+CoreDataProperties.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

extension UserRepository {
    @NSManaged var id: Int32
    @NSManaged var roadmap: NSSet?

}

// MARK: Generated accessors for roadmap
extension UserRepository {
    @objc(addRoadmapObject:)
    @NSManaged func addToRoadmap(_ value: RoadmapLocal)

    @objc(removeRoadmapObject:)
    @NSManaged func removeFromRoadmap(_ value: RoadmapLocal)

    @objc(addRoadmap:)
    @NSManaged func addToRoadmap(_ values: NSSet)

    @objc(removeRoadmap:)
    @NSManaged func removeFromRoadmap(_ values: NSSet)

}
