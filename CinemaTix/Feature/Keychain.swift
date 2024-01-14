//
//  Security.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation
import Security
import CryptoSwift

class Keychain {
    
    private static let serviceName = "CinemaTixKeyChain"
    private static let encryptionKey = "yourEncryptionKey123"
    private static let initializationVector = "1234567890123456"
    
    // Save username and password to Keychain
    static func saveCredentials(username: String, password: String) {
        
        do {
            let encryptedPassword = try encryptString(input: password, key: Keychain.encryptionKey, iv: Keychain.initializationVector)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: username,
                kSecValueData as String: encryptedPassword.data(using: .utf8)!
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Failed to save credentials to Keychain")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // Retrieve password from Keychain for a given username
    static func getPasswordForUsername(username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            if let password = String(data: data, encoding: .utf8) {
                do {
                    let decryptedString = try decryptString(input: password, key: Keychain.encryptionKey, iv: Keychain.initializationVector)
                    return decryptedString
                } catch {
                    print("Failed to decrypted password")
                }
            }
            return nil
        } else {
            print("Failed to retrieve password from Keychain")
            return nil
        }
    }
    
    static func isKeychainEmptyForUsername(username: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return status == errSecItemNotFound
    }
    
    // Function to encrypt a string
    static func encryptString(input: String, key: String, iv: String) throws -> String {
        let data = Data(input.utf8)
        let keyData = Data(key.utf8)
        let ivData = Data(iv.utf8)
        
        let encrypted = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7).encrypt(data.bytes)
        let encryptedData = Data(encrypted)
        
        return encryptedData.base64EncodedString()
    }
    
    // Function to decrypt a string
    static func decryptString(input: String, key: String, iv: String) throws -> String {
        guard let data = Data(base64Encoded: input) else {
            throw NSError(domain: "", code: 0)
        }
        
        let keyData = Data(key.utf8)
        let ivData = Data(iv.utf8)
        
        let decrypted = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7).decrypt(data.bytes)
        let decryptedData = Data(decrypted)
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw NSError(domain: "", code: 0)
        }
        
        return decryptedString
    }
}
