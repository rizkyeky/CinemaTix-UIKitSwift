//
//  OutlinedButton.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit

class OutlinedButton: UIButton {
    
    convenience init(title: String, icon: UIImage? = nil, iconSize: CGSize? = nil, onTap: (() -> Void)? = nil) {
        self.init(title: title, isBold: true, icon: icon, foregroundColor: AppColor.accent ?? .label, backgroundColor: .clear, tintBackgroundColor: AppColor.accent?.withAlphaComponent(0.1))
        
        makeBorder()
        
        if let onTap = onTap {
            addAction(UIAction { _ in
                onTap()
            }, for: .touchUpInside)
        }
    }
}
