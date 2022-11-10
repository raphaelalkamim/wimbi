//
//  SaveImageController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 28/10/22.
//

import Foundation
import UIKit

// transforma o formato da imagem jpg e "comprimir" em string
class SaveImagecontroller {
    // achar diretorio onde salva as imagens
    static func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // salvar arquivo
    static func saveToFiles(image: UIImage?, UUID: String) -> String {
        if let data = image?.jpegData(compressionQuality: 1) {
            let directory = getDocumentDirectory()
            let path = directory.appendingPathComponent("\(UUID).jpeg")
            print("\(UUID).jpeg")
            try? data.write(to: path)
            return path.lastPathComponent
        }
        return ""
    }
    
    // deletar arquivo
    static func deleteImage(path: String) -> Bool {
        let imagePath = getDocumentDirectory().appendingPathComponent(path)
        if FileManager.default.fileExists(atPath: imagePath.relativePath) {
            try? FileManager.default.removeItem(at: imagePath)
            return true
        }
        return false
    }
    
    // buscar imagens
    static func getFilePath(fileName: String) -> String {
        let imagePath = getDocumentDirectory().appendingPathComponent(fileName)
        return imagePath.relativePath
    }
    
}
