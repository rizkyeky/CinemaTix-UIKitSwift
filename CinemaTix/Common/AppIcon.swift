//
//  AppIcon.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation
import UIKit

enum AppIcon {
    static let home = UIImage(systemName: "house.fill")
    static let system = UIImage(systemName: "gear")
    static let add = UIImage(systemName: "plus")
    static let filter = UIImage(systemName: "line.3.horizontal.decrease")
    
    static let forward = UIImage(systemName: "chevron.right")
    static let back = UIImage(systemName: "chevron.left")
    
    static let search = UIImage(systemName: "magnifyingglass")
    static let setting = UIImage(systemName: "gear")
    static let profile = UIImage(systemName: "person")
    
    static let up = UIImage(systemName: "square.and.arrow.up")
    static let down = UIImage(systemName: "square.and.arrow.down")
    
    static let close = UIImage(systemName: "xmark")
}

enum AppSVGIcon: String {
    
    case apple = "logo-apple"
    case google = "logo-google"
    case email = "mail"
    case faceId = "face-id"
    
    case bag = "bag-check"
    case bagOutline = "bag-check-outline"
    case home = "home"
    case homeOutline = "home-outline"
    case wallet = "wallet"
    case walletOutline = "wallet-outline"
    case person = "person"
    case personOutline = "person-outline"
    
    func getImage() -> UIImage {
        guard let image = UIImage(named: rawValue) else {
            return UIImage(systemName: "xmark")!
        }
        return image
    }
}
