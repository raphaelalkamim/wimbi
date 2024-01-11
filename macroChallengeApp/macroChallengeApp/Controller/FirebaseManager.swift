//
//  FirebaseManager.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 07/11/22.
//

import Foundation
import FirebaseStorage
import FirebaseAnalytics
import UIKit

class FirebaseManager {
    public static var shared = FirebaseManager()
    public let imageCash = NSCache<NSString, UIImage>()
    
    private init() {}

    func uploadImageRoadmap(image: UIImage, roadmapId: Int, roadmapCore: Roadmap? = nil, uuid: String? = nil) {
        // create storage reference
        let storageRef = Storage.storage().reference()
        var uuidImage = ""
        
        // turn our image into data
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        guard let imageData = imageData else { return }
        
        if roadmapCore != nil {
            uuidImage = (roadmapCore?.imageId)!
        } else {
            uuidImage = uuid!
        }
        
        // specify file path and name
        let fileRef = storageRef.child("images/\(uuidImage)")
        
        // upload
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // save a reference to the file in Firestore
                print("ATUALIZAR IMAGEM BACK")
                DataManager.shared.putImageRoadmap(roadmapId: roadmapId, uuid: uuidImage)
                
            }
        }
    }
    
    func uploadImageUser(image: UIImage) {
        // create storage reference
        let storageRef = Storage.storage().reference()
        
        // turn our image into data
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        let userLocal = UserRepository.shared.getUser()
        
        guard let imageData = imageData, let uuidImage = userLocal[0].photoId else { return }
        
        // specify file path and name
        let fileRef = storageRef.child("profile/\(uuidImage)")
        
        // upload
        _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // save a reference to the file in Firestore
                print("ATUALIZAR IMAGEM BACK")
                DataManager.shared.putImageRoadmap(roadmapId: 0, uuid: uuidImage)
                
            }
        }
    }
    
    func getImage(category: Int, uuid: String, _ completion: @escaping ((_ image: UIImage) -> Void)) {
        var path = ""
        
        if category == 0 {
            path = "images/\(uuid)"
        } else {
            path = "profile/\(uuid)"
        }
        
        let reference = Storage.storage().reference(withPath: path)
        if self.imageCash.object(forKey: NSString(string: uuid)) != nil || !uuid.contains("jpeg") {
            return
        }
        print(uuid, "arroz")
        DispatchQueue.global(qos: .utility).async {
            reference.getData(maxSize: (1 * 1024 * 1024)) { data, error in
                if let err = error {
                    print(err)
                } else {
                    if let image = data {
                        let myImage: UIImage! = UIImage(data: image)
                        completion(myImage)
                        self.imageCash.setObject(myImage, forKey: NSString(string: uuid))
                    }
                }
            }
        }
    }
    
    func deleteImage(category: Int, uuid: String) {
        var path = ""
        
        if category == 0 {
            path = "images/\(uuid)"
        } else {
            path = "profile/\(uuid)"
        }
        
        let reference = Storage.storage().reference(withPath: path)
        
        reference.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Deletou")
            }
        }
    }
    
    func createAnalyticsEvent(event: String, parameters: [String: Any]? = nil ) {
        Analytics.logEvent(event, parameters: parameters)
    }
}
