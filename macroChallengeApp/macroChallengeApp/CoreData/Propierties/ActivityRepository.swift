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
    @NSManaged var budget: Double
    @NSManaged var currencyType: String?
    @NSManaged var tips: String?
    @NSManaged var category: String?
    @NSManaged var hour: Date?
    @NSManaged var id: Int32
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var day: DayLocal?
}
