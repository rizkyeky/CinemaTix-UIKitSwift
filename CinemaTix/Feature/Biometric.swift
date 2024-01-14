//
//  Biometric.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation
import LocalAuthentication

class BiometricAuth {
    
    let context = LAContext()
    
    func authenticate(onSuccess: @escaping () -> Void, onError: ((Error?) -> Void)?) {
        
        var error: NSError?
        
//        if let usernameDef = UserDefaults.standard.value(forKey: "username") as? String {
//            if Keychain.isKeychainEmptyForUsername(username: usernameDef) {
//                
//            } else {
//                onError?(NSError())
//            }
//        } else {
//            onError?(NSError())
//        }
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authentication required to open app"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                        onSuccess()
                    }
                } else {
                    if let error = error {
                        onError?(error)
                    } else {
                        onError?(NSError())
                    }
                }
            }
        } else {
            onError?(NSError())
        }
    }
}
