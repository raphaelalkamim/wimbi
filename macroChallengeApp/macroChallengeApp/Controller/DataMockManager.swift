//
//  DataMockManager.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 04/11/22.
//

import Foundation
import UIKit

class DataMockManager {
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    func parseDTO(jsonData: Data) -> [RoadmapDTO]? {
        do {
            let decodedData = try JSONDecoder().decode([RoadmapDTO].self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print("decode error")
        }
        return nil
    }
    
    func parse(jsonData: Data) -> [Roadmaps]? {
        do {
            let decodedData = try JSONDecoder().decode([Roadmaps].self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print(error)
        }
        return nil
    }
}
