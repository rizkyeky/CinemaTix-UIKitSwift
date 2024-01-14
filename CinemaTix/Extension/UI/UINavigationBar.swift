//
//  UINavigationBar.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit

extension UINavigationBar {
    func addHeader() {
        backgroundColor = .secondarySystemBackground
        addBottomBorder(with: AppColor.separator, height: 1)
        let indicator = UIView(frame: .init(x: (bounds.width/2)-24, y: 8, width: 48, height: 4), color: .separator)
        indicator.makeCornerRadiusRounded()
        addSubview(indicator)
    }
    func addBottomBorder(with color: UIColor, height: CGFloat) {
        let separator = UIView()
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        separator.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
        addSubview(separator)
    }
}
