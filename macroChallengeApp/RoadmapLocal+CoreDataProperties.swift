//
//  RoadmapLocal+CoreDataProperties.swift
//  
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

extension RoadmapLocal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoadmapLocal> {
        return NSFetchRequest<RoadmapLocal>(entityName: "RoadmapLocal")
    }

    @NSManaged public var budget: Double
    @NSManaged public var category: String?
    @NSManaged public var dayCount: Int32
    @NSManaged public var id: Int32
    @NSManaged public var imageId: String?
    @NSManaged public var isPublic: Bool
    @NSManaged public var isShared: Bool
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var peopleCount: Int32
    @NSManaged public var shareKey: String?
    @NSManaged public var day: NSSet?
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for day
extension RoadmapLocal {
    @objc(addDayObject:)
    @NSManaged public func addToDay(_ value: DayLocal)

    @objc(removeDayObject:)
    @NSManaged public func removeFromDay(_ value: DayLocal)

    @objc(addDay:)
    @NSManaged public func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged public func removeFromDay(_ values: NSSet)

}

// MARK: Generated accessors for user
extension RoadmapLocal {
    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: UserLocal)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: UserLocal)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}
