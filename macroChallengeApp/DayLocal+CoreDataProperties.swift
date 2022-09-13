//
//  DayLocal+CoreDataProperties.swift
//  
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

extension DayLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayLocal> {
        return NSFetchRequest<DayLocal>(entityName: "DayLocal")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: Int32
    @NSManaged public var activity: NSSet?
    @NSManaged public var roadmap: RoadmapLocal?

}

// MARK: Generated accessors for activity
extension DayLocal {
    @objc(addActivityObject:)
    @NSManaged public func addToActivity(_ value: ActivityLocal)

    @objc(removeActivityObject:)
    @NSManaged public func removeFromActivity(_ value: ActivityLocal)

    @objc(addActivity:)
    @NSManaged public func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged public func removeFromActivity(_ values: NSSet)

}
