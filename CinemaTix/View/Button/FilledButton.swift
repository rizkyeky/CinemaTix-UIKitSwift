//
//  PrimaryButton.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit

class FilledButton: UIButton {
    
    convenience init(title: String, icon: UIImage? = nil, iconSize: CGSize? = nil, backgroundColor: UIColor? = nil, foregroundColor: UIColor? = nil, onTap: (() -> Void)? = nil) {
        
        self.init(title: title, isBold: true, icon: icon, iconSize: iconSize, foregroundColor: foregroundColor ?? .white, backgroundColor: backgroundColor ?? AppColor.accent)
        
        if let onTap = onTap {
            addAction(UIAction { _ in
                onTap()
            }, for: .touchUpInside)
        }
    }
     
}

