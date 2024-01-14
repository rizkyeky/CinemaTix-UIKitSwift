//
//  UIBarButtonItem.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(image: UIImage?, action: UIAction) {
        self.init()
        self.image = image
        primaryAction = action
    }
}
