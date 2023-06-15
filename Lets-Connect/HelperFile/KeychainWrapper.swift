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
#if DEBUG
            print("saved to keychain")
#endif

            
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
    
    
    static func deleteUserFromKeychain(forKey key: String) -> Bool{
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
#if DEBUG
            print("Keychain item deleted successfully.")
#endif
            return true
            
        } else if let error = SecCopyErrorMessageString(status, nil) {
#if DEBUG
            print("Error deleting Keychain item: \(error)")
#endif
           return false
        } else {
#if DEBUG
            print("Unknown error deleting Keychain item.")
#endif
            return false
        }
       
    }
    
}
enum KeychainError: Error {
      case unhandledError(status: OSStatus)
  }


