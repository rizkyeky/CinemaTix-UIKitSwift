//
//  Auth.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation
import FirebaseAuth

class FireAuth {
    
    private let auth = Auth.auth()
    private let database = FireDatabase()
    
    func getCurrUser(onSuccess: @escaping ((UserModel?) -> Void), onError: ((AppError) -> Void)? = nil) {
        if let user = auth.currentUser {
            if let userEmail = user.email {
                self.database.getUserBy(email: userEmail) { user in
                    onSuccess(user)
                } onError: { error in
                    onError?(error)
                }
            } else {
                onSuccess(nil)
            }
        } else {
            onSuccess(nil)
        }
    }
    
    func signIn(email: String, password: String, onSuccess: @escaping ((UserModel) -> Void), onError: ((AppError) -> Void)? = nil) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let _error = error {
                onError?(AppError(message: _error.localizedDescription))
            }
            if let fireUser = result?.user {
                if let userEmail = fireUser.email {
                    self.database.getUserBy(email: userEmail) { user in
                        onSuccess(user)
                    } onError: { error in
                        onError?(error)
                    }
                }
            } else {
                onError?(AppError(message: "User is not found"))
            }
        }
    }
    
    func register(user: UserModel, password: String, onSuccess: @escaping ((FirebaseAuth.User, String?) -> Void), onError: ((AppError) -> Void)? = nil) {
        if let email = user.email {
            auth.createUser(withEmail: email, password: password) { result, error in
                if let _error = error {
                    onError?(AppError(message: _error.localizedDescription))
                }
                if let _result = result {
                    self.database.addUser(user: user) { id in
                        onSuccess(_result.user, id)
                    } onError: { error in
                        onError?(error)
                    }
                } else {
                    onError?(AppError(message: "User is not found"))
                }
            }
        }
    }
    
    func signOut(onSuccess: @escaping (() -> Void), onError: ((AppError) -> Void)? = nil) {
        do {
            try auth.signOut()
            onSuccess()
        } catch let signOutError as NSError {
            onError?(AppError(message: signOutError.localizedDescription))
        }
    }
}
