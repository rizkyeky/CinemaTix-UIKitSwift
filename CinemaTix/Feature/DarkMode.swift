//
//  DarkMode.swift
//  CinemaTix
//
//  Created by Eky on 27/12/23.
//

import Foundation
import UIKit

class DarkMode {
    
    static let activated = DarkMode()
    
    private var _isActive: Bool = false
    
    var isActive: Bool {
        get {
            return _isActive
        }
    }
    
    private let defaults = UserDefaults.standard
    
    func setup(window: UIWindow, completion: (Bool) -> Void = { _ in }) {
        _isActive = defaults.bool(forKey: "dark_mode")
        if (_isActive) {
            window.overrideUserInterfaceStyle = .dark
        }
        if (window.overrideUserInterfaceStyle == .dark && !_isActive) {
            _isActive = true
        }
        completion(_isActive)
    }
    
    func toggle(completion: (Bool) -> Void = { _ in }) {
        turnOnOffUIStyle()
        _isActive.toggle()
        defaults.set(_isActive, forKey: "dark_mode")
        completion(_isActive)
    }
    
    private func turnOnOffUIStyle() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let windows = windowScene.windows
                for window in windows {
                    if (!_isActive) {
                        window.overrideUserInterfaceStyle = .dark
                    } else {
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            }
        }
    }
}
