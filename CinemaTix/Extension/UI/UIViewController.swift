//
//  UIViewController.swift
//  CinemaTix
//
//  Created by Eky on 14/12/23.
//

import UIKit

extension UIViewController {
    func topSafeAreaHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            if #available(iOS 15.0, *) {
                let window = view.window?.windowScene?.windows[0] ?? navigationController?.navigationBar.window
                let topPadding = window?.safeAreaInsets.top ?? 0.0
                return topPadding
            } else {
                let window = UIApplication.shared.windows[0]
                let topPadding = window.safeAreaInsets.top
                return topPadding
            }
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    func navBarHeight() -> CGFloat {
        if let navbarHeight = navigationController?.navigationBar.frame.height {
            return navbarHeight
        } else {
            return 0.0
        }
    }
    func navBarSafeAreaHeight() -> CGFloat {
        return navBarHeight() + topSafeAreaHeight()
    }
}
