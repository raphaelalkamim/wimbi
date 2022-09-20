//
//  ActivityLocal+CoreDataProperties.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

extension ActivityRepository {

    @NSManaged public var budget: Double
    @NSManaged public var category: String?
    @NSManaged public var hour: Date?
    @NSManaged public var id: Int32
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var day: DayLocal?

}
