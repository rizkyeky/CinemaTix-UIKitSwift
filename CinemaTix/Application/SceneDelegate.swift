//
//  SceneDelegate.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let launchVC = LaunchViewController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: launchVC)
        window?.makeKeyAndVisible()
        
        if let window = window {
            DarkMode.activated.setup(window: window)
        }
    }

}

