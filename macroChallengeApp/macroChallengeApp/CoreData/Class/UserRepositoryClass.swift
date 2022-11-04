//
//  UserLocal+CoreDataClass.swift
//
//
//  Created by Carolina Ortega on 13/09/22.
//
//

import Foundation
import CoreData

class UserRepository: NSManagedObject {
    static let shared: UserRepository = UserRepository()
    
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
    
    func createUser(user: User) -> UserLocal {
        guard let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserLocal", into: context) as? UserLocal else { preconditionFailure() }
        
        newUser.id = Int32(user.id)
        newUser.name = user.name
        newUser.usernameApp = user.usernameApp
        
        self.saveContext()
        return newUser
    }
    
    func getUser() -> [UserLocal] {
        let fetchRequest = NSFetchRequest<UserLocal>(entityName: "UserLocal")
        do {
            return try self.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return []
    }
    func updateName(user: UserLocal, name: String) {
        user.name = name
        self.saveContext()
    }
    func updateUsernameApp(user: UserLocal, username: String) {
        user.usernameApp = username
        self.saveContext()
    }
    func updatePhotoId(user: UserLocal, photoId: String) {
        user.photoId = photoId
        self.saveContext()
    }
    func deleteUser(user: UserLocal) throws {
        self.persistentContainer.viewContext.delete(user)
        self.saveContext()
    }
}
