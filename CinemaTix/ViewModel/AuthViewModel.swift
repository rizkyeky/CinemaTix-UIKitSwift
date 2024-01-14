//
//  AuthViewModel.swift
//  CinemaTix
//
//  Created by Eky on 18/12/23.
//

import Foundation

class AuthViewModel: BaseViewModel {
    
    private let fireAuth = FireAuth()
    
    func checkActiveUser(onSuccess: @escaping ((UserModel?) -> Void), onError: ((Error) -> Void)? = nil) {
        fireAuth.getCurrUser { user in
            if let _user = user {
                UserModel.registered = _user
                onSuccess(UserModel.registered)
            } else {
                onSuccess(nil)
            }
        } onError: { error in
            onError?(error)
        }
    }
    
    func signOut(onSuccess: @escaping (() -> Void), onError: ((Error) -> Void)? = nil) {
        fireAuth.signOut {
            onSuccess()
            UserModel.registered = nil
        } onError: { error in
            onError?(error)
            UserModel.registered = nil
        }
    }
}
