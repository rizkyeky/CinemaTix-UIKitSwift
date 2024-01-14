//
//  SignInViewModel.swift
//  CinemaTix
//
//  Created by Eky on 20/12/23.
//

import Foundation

class SingInViewModel: BaseViewModel {
    
    var email: String?
    var password: String?
    
    private let fireAuth = FireAuth()
    
    func signInWithFB(onSuccess: @escaping (() -> Void), onError: ((Error) -> Void)? = nil, onInvalidEmail: (() -> Void)? = nil, onInvalidPassword: (() -> Void)? = nil) {
        if let correctEmail = email, !correctEmail.isEmpty, correctEmail.isValidEmail() {
            if let correctPass = password, !correctPass.isEmpty {
                fireAuth.signIn(email: correctEmail, password: correctPass) { user in
                    UserModel.registered = user
                    onSuccess()
                    self.email = nil
                    self.password = nil
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
