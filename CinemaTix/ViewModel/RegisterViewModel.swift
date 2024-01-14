//
//  RegisterViewModel.swift
//  CinemaTix
//
//  Created by Eky on 20/12/23.
//

import Foundation

class RegisterViewModel: BaseViewModel {
    
    var email: String?
    var password: String?
    var username: String?
    
    private let fireAuth = FireAuth()
    
    func registerWithFB(onSuccess: @escaping (() -> Void), onError: ((Error) -> Void)? = nil, onInvalidEmail: (() -> Void)? = nil, onInvalidPassword: (() -> Void)? = nil) {
        
        if let correctEmail = email, !correctEmail.isEmpty, correctEmail.isValidEmail() {
            if let correctPass = password, !correctPass.isEmpty {
                let _user = UserModel(email: correctEmail)
                fireAuth.register(user: _user, password: correctPass) { auth, id in
                    if auth.email == correctEmail {
                        UserModel.registered = _user
                        UserModel.registered?.id = id
                        UserModel.registered?.username = self.username
                        UserModel.registered?.displayName = auth.displayName
                        onSuccess()
                        self.email = nil
                        self.password = nil
                        self.username = nil
                    }
                } onError: { error in
                    onError?(error)
                }
            } else {
                onInvalidPassword?()
            }
        } else {
            onInvalidEmail?()
        }
    }
}
