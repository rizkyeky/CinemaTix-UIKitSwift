//
//  ErrorService.swift
//  CinemaTix
//
//  Created by Eky on 27/11/23.
//

import Foundation

class AppError: Error {
    var message: String?
    
    init(message: String? = nil) {
        self.message = message
    }
}
