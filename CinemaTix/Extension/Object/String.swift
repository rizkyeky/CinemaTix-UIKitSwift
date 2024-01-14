//
//  ExtString.swift
//  CinemaTix
//
//  Created by Eky on 13/11/23.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        guard let regex = try? NSRegularExpression(pattern: emailRegex, options: []) else {
            return false
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        
        return !matches.isEmpty
    }
}
