//
//  TextedButton.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit

class TextButton: UIButton {
    
    convenience init(withTitle: String? = nil, icon: UIImage? = nil, size: CGSize? = nil, iconSize: CGSize? = nil, onTap: (() -> Void)? = nil) {
        let frame = size != nil ? CGRect(origin: CGPoint(x: 0, y: 0), size: size ?? CGSize()) : .init(x: 0, y: 0, width: 300, height: 48)
        self.init(title: withTitle ?? "", isBold: true, icon: icon, iconSize: iconSize, foregroundColor: AppColor.accent ?? .label, backgroundColor: .clear, frame: frame)
        
        if let onTap = onTap {
            addAction(UIAction { _ in
                onTap()
            }, for: .touchUpInside)
        }
    }
}
