//
//  ExtUIButton.swift
//  CinemaTix
//
//  Created by Eky on 06/11/23.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, isBold: Bool = false, icon: UIImage? = nil, iconSize: CGSize? = nil, foregroundColor: UIColor = .white, backgroundColor: UIColor? = AppColor.accent, frame: CGRect = .init(x: 0, y: 0, width: 300, height: 48), cornerRadius: Double = 8.0, tintBackgroundColor: UIColor? = nil) {
        self.init(frame: frame)
        
        var attributes: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.foregroundColor: foregroundColor
        ]
        if isBold {
            attributes[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 18)
        }
        let titleAttributed = NSMutableAttributedString(string: title, attributes: attributes)
        setAttributedTitle(titleAttributed, for: .normal)
        
        self.backgroundColor = backgroundColor
        self.tintColor = foregroundColor
        
        setAnimateBounce(tintBackgroundColor: tintBackgroundColor)
        makeCornerRadius(cornerRadius)
        
        if let icon = icon?.resize(iconSize ?? CGSize(width: 32, height: 32)) {
            let image = UIImageView(image: icon.reColor(foregroundColor))
            image.tintColor = foregroundColor
            addSubview(image)
            image.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.left.equalTo(self).offset(16)
                make.width.equalTo(iconSize?.width ?? 32)
                make.height.equalTo(iconSize?.height ?? 32)
            }
        }
    }
    
    func setAnimateBounce(withDuration: Double = 0.081, scale: Double = 0.96, tintBackgroundColor: UIColor? = nil) {
        let oriBackColor = self.backgroundColor
        self.addAction(UIAction { _ in
            self.onTapDownAnimateBounce(withDuration, scale, tintBackgroundColor: tintBackgroundColor)
        }, for: .touchDown)
        self.addAction(UIAction { _ in
            self.onTapUpAnimateBounce(withDuration, oriBackColor: oriBackColor)
        }, for: .touchUpInside)
        self.addAction(UIAction { _ in
            self.onTapUpAnimateBounce(withDuration, oriBackColor: oriBackColor)
        }, for: .touchUpOutside)
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
