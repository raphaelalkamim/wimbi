//
//  DayLocal+CoreDataClass.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

class DayRepository: NSManagedObject {
    static let shared: DayRepository = DayRepository()
    
    func createDay(roadmap: Roadmap, day: Day) {
        
    }
    
    func getDay() -> [Day] {
        return []
    }
    
    func deleteDay(day: Day) throws {

    }
    
}
