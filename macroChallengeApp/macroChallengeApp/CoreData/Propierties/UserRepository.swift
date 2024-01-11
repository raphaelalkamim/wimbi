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
    @NSManaged var name: String
    @NSManaged var usernameApp: String
    @NSManaged var photoId: String
    @NSManaged var currencyType: String
    @NSManaged var roadmap: NSSet?

}
