//
//  IconButton.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit

class IconButton: UIButton {
    
    convenience init(icon: UIImage?, size: CGSize? = nil, iconSize: CGSize? = nil, onTap: (() -> Void)? = nil) {
        
        self.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size ?? CGSize(width: 40, height: 40)))
        
        if let icon = icon {
            setImage(icon.resize(iconSize ?? CGSize(width: 24, height: 24)), for: .normal)
        }
        setTitleColor(AppColor.accent ?? .systemBlue, for: .normal)
        let titleAttributed = NSMutableAttributedString(string: "", attributes: [
            NSAttributedString.Key.foregroundColor: AppColor.accent ?? .systemBlue
        ])
        setAttributedTitle(titleAttributed, for: .normal)
        setAnimateBounce()
        
        if let onTap = onTap {
            addAction(UIAction { _ in
                onTap()
            }, for: .touchUpInside)
        }
    }
}
