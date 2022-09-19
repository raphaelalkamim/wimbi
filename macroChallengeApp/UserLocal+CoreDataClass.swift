//
//  UserLocal+CoreDataClass.swift
//  
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

@objc(UserLocal)
public class UserLocal: NSManagedObject {
    static let shared: UserLocal = UserLocal()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "macroChallengeApp")
        container.loadPersistentStores { _, error in
            if let erro = error {
                preconditionFailure(erro.localizedDescription)
            }
            
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Problema de contexto: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createUser(user: User) -> ActivityLocal {
        guard let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserLocal", into: context) as? UserLocal else { preconditionFailure() }
        
        newUser.id = user.id
        
        self.saveContext()
        return newUser
    }
    
    func getUser() -> [UserLocal] {
        let fr = NSFetchRequest<UserLocal>(entityName: "UserLocal")
        do {
            return try self.persistentContainer.viewContext.fetch(fr)
        } catch {
            print(error)
        }
        return []
    }
    
    func deleteUser(user: UserLocal) throws {
        self.persistentContainer.viewContext.delete(user)
        self.saveContext()
    }
}
