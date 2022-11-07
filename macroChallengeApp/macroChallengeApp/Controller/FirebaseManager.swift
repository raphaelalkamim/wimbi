//
//  FirebaseManager.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 07/11/22.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseManager {
    public static var shared = FirebaseManager()
    public let imageCash = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func uploadImage(image: UIImage, roadmapId: Int, roadmapCore: RoadmapLocal) {
        // create storage reference
        let storageRef = Storage.storage().reference()
        
        // turn our image into data
        let imageData = image.jpegData(compressionQuality: 0.7)
        
        guard let imageData = imageData, let uuidImage = roadmapCore.imageId else { return }
        
        // specify file path and name
        let fileRef = storageRef.child("images/\(uuidImage)")
        
        // upload
        let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // save a reference to the file in Firestore
                print("ATUALIZAR IMAGEM BACK")
                DataManager.shared.putImageRoadmap(roadmapId: roadmapId, uuid: uuidImage)
                
            }
        }
    }
    
    func getImage(uuid: String) {
        let path = "images/\(uuid)"
        let reference = Storage.storage().reference(withPath: path)
        DispatchQueue.global(qos: .utility).async {
            reference.getData(maxSize: (1 * 1024 * 1024)) { data, error in
                if let err = error {
                    print(err)
                } else {
                    if let image = data {
                        let myImage: UIImage! = UIImage(data: image)
                        self.imageCash.setObject(myImage, forKey: NSString(string: uuid))

                    }
                }
            }
        }
        
    }
    
    
    func deleteImage(uuid: String) {
        let path = "images/\(uuid)"
        let reference = Storage.storage().reference(withPath: path)
        
        reference.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Deletou")
            }
        }
    }
}
