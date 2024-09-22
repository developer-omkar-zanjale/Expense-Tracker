//
//  KeyChainService.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 22/09/24.
//

import Foundation
import Security

class SecureService {
    
    let logService = LoggerService()
    
    func savePassword(_ password: String, for userName: String) {
        if let passwordData = password.data(using: .utf8) {
            let attributes: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: userName,
                kSecValueData as String: passwordData
            ]
            if SecItemAdd(attributes as CFDictionary, nil) == noErr {
                logService.printLog("KeyChain: Password saved in keychain.")
            } else {
                logService.printLog("KeyChain: Unable to save password in keychain!")
            }
        } else {
            logService.printLog("KeyChain: Error while converting password to Data!")
        }
    }
    
    func getPassword(for userName: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var passwordRef: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &passwordRef) == noErr {
            if
                let existingItem = passwordRef as? [String: Any],
                let passwordData = existingItem[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: .utf8) {
                return password
            } else {
                logService.printLog("KeyChain: Unable to get password from keychain!")
            }
        } else {
            logService.printLog("KeyChain: Password not found for username: \(userName) in keychain!")
        }
        return nil
    }
    
    func deletePassword(for userName: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName
        ]
        if SecItemDelete(query as CFDictionary) == noErr {
            logService.printLog("KeyChain: Password deleted successfully for \(userName)")
        } else {
            logService.printLog("KeyChain: Unable to delete password for \(userName)")
        }
    }
    
    //Encode
    static func encode(str: String) -> String? {
        return Data(str.utf8).base64EncodedString()
    }
    
    //Decode
    static func decode(str: String) -> String? {
        let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters)
        if data != nil {
            return String(data: data!, encoding: .utf8)
        }
        return nil
    }
    
}
