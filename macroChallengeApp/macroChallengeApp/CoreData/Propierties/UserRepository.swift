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

    @NSManaged public var id: Int32
    @NSManaged public var roadmap: NSSet?

}

// MARK: Generated accessors for roadmap
extension UserRepository {
    @objc(addRoadmapObject:)
    @NSManaged public func addToRoadmap(_ value: RoadmapLocal)

    @objc(removeRoadmapObject:)
    @NSManaged public func removeFromRoadmap(_ value: RoadmapLocal)

    @objc(addRoadmap:)
    @NSManaged public func addToRoadmap(_ values: NSSet)

    @objc(removeRoadmap:)
    @NSManaged public func removeFromRoadmap(_ values: NSSet)

}
