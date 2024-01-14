//
//  TransactionModel.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation

enum TransType: Int {
    case income, outcome
    
    static func from(_ ind: Int?) -> TransType? {
        if let index = ind {
            return TransType.init(rawValue: index)
        } else {
            return nil
        }
    }
}

struct Transaction {
    var id: String?
    var label: String?
    let amount: Double?
    var desc: String?
    var type: TransType?
    
    init(id: String? = nil, label: String? = nil, amount: Double? = nil, desc: String? = nil, type: Int? = nil) {
        self.id = id
        self.label = label
        self.amount = amount
        self.desc = desc
        self.type = TransType.from(type)
    }
    
    func toDict() -> [String: Any] {
        return [
            "label": self.label ?? "",
            "desc": self.desc ?? "",
            "amount": self.amount ?? 0,
            "type": self.type?.rawValue ?? 0,
        ]
    }
    
    static func fromDict(_ dict: [String: Any?]) -> Transaction {
        return Transaction(
            label: dict["label"] as? String,
            amount: dict["amount"] as? Double,
            desc: dict["desc"] as? String,
            type: dict["type"] as? Int
        )
    }
}
