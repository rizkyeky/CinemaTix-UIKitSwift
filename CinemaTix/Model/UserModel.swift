//
//  UserMode.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation
import FirebaseFirestoreInternal

struct UserModel {
    
    static var registered: UserModel?
    
    var id: String?
    var email: String?
    var username: String?
    var displayName: String?
    var birthDate: Date?
    var gender: Gender?
    var wallet: WalletModel?
    
    init(id: String? = nil, email: String?, displayName: String? = nil, birthDate: Date? = nil, username: String? = nil, gender: Int? = nil, wallet: String? = nil) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.birthDate = birthDate
        self.email = email
        self.gender = Gender.from(gender)
        self.wallet = WalletModel(id: wallet)
    }
    
    func toDict() -> [String: Any] {
        return [
            "email": self.email ?? "",
            "displayName": self.displayName ?? "",
            "birthDate": Timestamp(date: self.birthDate ?? Date()),
            "username": self.username ?? "",
            "gender": self.gender ?? 0,
            "wallet": self.wallet?.id ?? ""
        ]
    }
    
    static func fromDict(_ dict: [String: Any?]) -> UserModel {
        return UserModel(
            email: dict["email"] as? String,
            displayName: dict["displayName"] as? String,
            birthDate: (dict["birthDate"] as? Timestamp)?.dateValue(),
            username: dict["username"] as? String,
            gender: dict["gender"] as? Int,
            wallet: dict["walletId"] as? String
        )
    }
}

enum Gender: Int {
    case male
    case female
    
    static func from(_ index: Int?) -> Gender? {
        if let _index = index {
            return Gender.init(rawValue: _index)
        } else {
            return nil
        }
    }
    
    func toStr() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
