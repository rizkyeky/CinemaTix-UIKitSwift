//
//  TintedButton.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit

class TintedButton: UIButton {
    
    convenience init(title: String, icon: UIImage? = nil, size: CGSize? = nil, iconSize: CGSize? = nil, onTap: (() -> Void)? = nil) {
        let frame = size != nil ? CGRect(origin: CGPoint(x: 0, y: 0), size: size ?? CGSize()) : .init(x: 0, y: 0, width: 300, height: 48)
        
        self.init(title: title, isBold: true, icon: icon, iconSize: iconSize, foregroundColor: AppColor.accent ?? .label, backgroundColor: AppColor.accent?.withAlphaComponent(0.12), frame: frame, tintBackgroundColor: AppColor.accent?.withAlphaComponent(0.32))
        
        if let onTap = onTap {
            addAction(UIAction { _ in
                onTap()
            }, for: .touchUpInside)
        }
    }
}
