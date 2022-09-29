//
//  RoadmapLocal+CoreDataProperties.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

extension RoadmapRepository {
    @NSManaged var budget: Double
    @NSManaged var category: String?
    @NSManaged var dayCount: Int32
    @NSManaged var id: Int32
    @NSManaged var imageId: String?
    @NSManaged var isPublic: Bool
    @NSManaged var isShared: Bool
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var peopleCount: Int32
    @NSManaged var shareKey: String?
    @NSManaged var day: NSSet?
    @NSManaged var user: NSSet?
    @NSManaged var createdAt: Date?
    @NSManaged var date: Date?
}

// MARK: Generated accessors for day
extension RoadmapRepository {
    @objc(addDayObject:)
    @NSManaged func addToDay(_ value: DayLocal)

    @objc(removeDayObject:)
    @NSManaged func removeFromDay(_ value: DayLocal)

    @objc(addDay:)
    @NSManaged func addToDay(_ values: NSSet)

    @objc(removeDay:)
    @NSManaged func removeFromDay(_ values: NSSet)

}

// MARK: Generated accessors for user
extension RoadmapRepository {
    @objc(addUserObject:)
    @NSManaged func addToUser(_ value: UserLocal)

    @objc(removeUserObject:)
    @NSManaged func removeFromUser(_ value: UserLocal)

    @objc(addUser:)
    @NSManaged func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged func removeFromUser(_ values: NSSet)

}
