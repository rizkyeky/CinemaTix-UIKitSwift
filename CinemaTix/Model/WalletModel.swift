//
//  WalletModel.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation

struct WalletModel {
    
    var id: String?
    var label: String?
    var desc: String?
    var transactions: [String]?
    
    init(id: String? = nil, label: String? = nil, desc: String? = nil, amount: Double? = nil, transactions: [String]? = nil) {
        self.id = id
        self.label = label
        self.desc = desc
        self.transactions = transactions
    }
    
    func toDict() -> [String: Any] {
        return [
            "label": self.label ?? "",
            "desc": self.desc ?? "",
            "transactions": self.transactions ?? [],
        ]
    }
    
    static func fromDict(_ dict: [String: Any?]) -> WalletModel {
        return WalletModel(
            label: (dict["label"] as? String),
            desc: dict["desc"] as? String,
            transactions: dict["transactions"] as? [String]
        )
    }
    
}
