//
//  KeychainWrapper.swift
//  Lets-Connect
//
//  Created by HD-045 on 16/05/23.
//

import Foundation
import Security


struct KeychainWrapper{
    
    static func saveToKeyChain(key: String, data:Data) throws {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String : data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            
            throw KeychainError.unhandledError(status: status)
          
        }
        else{
            print("saved to keychain")
        }
    }
    
    static func loadFromKeyChain(key:String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess{
            return result as? Data
        }
        else if status == errSecItemNotFound{
            return nil
        }
        else{
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    
    static func deleteKeychainItem(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Keychain item deleted successfully.")
        } else if let error = SecCopyErrorMessageString(status, nil) {
            print("Error deleting Keychain item: \(error)")
        } else {
            print("Unknown error deleting Keychain item.")
        }
    }
}
enum KeychainError: Error {
      case unhandledError(status: OSStatus)
  }
