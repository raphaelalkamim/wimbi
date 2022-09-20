//
//  KeychainManager.swift
//  macroChallengeApp
//
//  Created by Luca Hummel on 14/09/22.
//

import Security
import Foundation

class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    func save(_ value: String, service: String, account: String) throws {
        let data = value.data(using: .utf8)
        
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            let atributtesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(query, atributtesToUpdate)
        } else if status != errSecSuccess {
            print(status)
        }
    }
    
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
