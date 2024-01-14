//
//  Language.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation

enum LanguageStrings: String {
    case signIn
    case home
    case wallet
    case profile
    case playingNow
    case upcoming
    case recommendedForYou
    case topRated
    
    var localized: String {
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
}
