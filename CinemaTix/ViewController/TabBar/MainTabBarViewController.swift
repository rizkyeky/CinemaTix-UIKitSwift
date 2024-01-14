//
//  MainTabBarViewController.swift
//  CinemaTix
//
//  Created by Eky on 15/12/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.delegate = self
        
        let home = UINavigationController(rootViewController: HomeViewController())
        let wallet = UINavigationController(rootViewController: WalletViewController())
        let profile = UINavigationController(rootViewController: ProfileViewController())
        
        let homeImage = AppSVGIcon.homeOutline.getImage().resize(CGSize(width: 24, height: 24))
        home.tabBarItem = UITabBarItem(title: LanguageStrings.home.localized, image: homeImage, tag: 0)
        home.tabBarItem.selectedImage = AppSVGIcon.home.getImage().resize(CGSize(width: 30, height: 30))
        
        let walletImage = AppSVGIcon.walletOutline.getImage().resize(CGSize(width: 24, height: 24))
        wallet.tabBarItem = UITabBarItem(title: LanguageStrings.wallet.localized, image: walletImage, tag: 1)
        wallet.tabBarItem.selectedImage = AppSVGIcon.wallet.getImage().resize(CGSize(width: 30, height: 30))
        
        let profileImage = AppSVGIcon.personOutline.getImage().resize(CGSize(width: 24, height: 24))
        profile.tabBarItem = UITabBarItem(title: LanguageStrings.profile.localized, image: profileImage, tag: 2)
        profile.tabBarItem.selectedImage = AppSVGIcon.person.getImage().resize(CGSize(width: 30, height: 30))
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor.accent
        
        setViewControllers([home, wallet, profile], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

//extension MainTabBarViewController: UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
//
//}
