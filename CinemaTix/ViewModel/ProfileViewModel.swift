//
//  ProfileViewModel.swift
//  CinemaTix
//
//  Created by Eky on 27/12/23.
//

import Foundation

class ProfileViewModel: BaseViewModel {
    
    var user: UserModel? {
        get {
            return UserModel.registered
        }
    }
}
