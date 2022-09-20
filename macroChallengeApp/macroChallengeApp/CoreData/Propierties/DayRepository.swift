//
//  DayLocal+CoreDataProperties.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

extension DayRepository {
    @NSManaged var date: String?
    @NSManaged var id: Int32
    @NSManaged var activity: NSSet?
    @NSManaged var roadmap: RoadmapLocal?

}

// MARK: Generated accessors for activity
extension DayRepository {
    @objc(addActivityObject:)
    @NSManaged func addToActivity(_ value: ActivityLocal)

    @objc(removeActivityObject:)
    @NSManaged func removeFromActivity(_ value: ActivityLocal)

    @objc(addActivity:)
    @NSManaged func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged func removeFromActivity(_ values: NSSet)

}
