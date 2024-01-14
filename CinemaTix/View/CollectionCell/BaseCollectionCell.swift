//
//  BaseCollectionCell.swift
//  CinemaTix
//
//  Created by Eky on 15/12/23.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    open var onTap: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setup() {
        
    }
}

extension BaseCollectionCell: UIGestureRecognizerDelegate {
    
    internal override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTapUpAnimateBounce(0.096)
        onTap?()
    }
    
    internal override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTapUpAnimateBounce(0.096)
    }
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTapDownAnimateBounce(0.096, 0.96, tintBackgroundColor: .lightGray.withAlphaComponent(0.2))
    }
    
    private func onTapDownAnimateBounce(_ withDuration: Double, _ scale: Double, tintBackgroundColor: UIColor? = nil) {
        UIView.animate(withDuration: withDuration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            if let tintBackgroundColor = tintBackgroundColor {
                self.backgroundColor = tintBackgroundColor
            }
        })
    }
    
    private func onTapUpAnimateBounce(_ withDuration: Double, oriBackColor: UIColor? = nil) {
        UIView.animate(withDuration: withDuration, animations: {
            self.transform = CGAffineTransform.identity
            if let oriBackColor = oriBackColor {
                self.backgroundColor = oriBackColor
            }
        })
    }
    
    
}
