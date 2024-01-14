//
//  ExtNSNumber.swift
//  CinemaTix
//
//  Created by Eky on 17/11/23.
//

import Foundation

extension NSNumber {
    func toDecimalString() -> String {
        let currencyFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 3
            return formatter
        }()
        let numberFormatter = currencyFormatter
        if let formattedString = numberFormatter.string(from: self) {
            return formattedString
        } else {
            return "\(self)"
        }
    }
}
