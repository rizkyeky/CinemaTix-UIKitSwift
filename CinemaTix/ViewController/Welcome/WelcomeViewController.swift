//
//  WelcomeViewController.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    private let logoIconImage = {
        let image = UIImageView(image: UIImage(named: "Icon"))
        image.frame = .init(x: 0, y: 0, width: 160, height: 160)
        return image
    }()
    
    private let signInButton = {
        let button = OutlinedButton(title: "Sign In")
        return button
    }()
    
    private let registerButton = {
        let button = FilledButton(title: "Register")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.addAction(UIAction { _ in
            self.showBottomSheet(to: SignInOptionsSheetViewController {
                self.navigationController?.setViewControllers([MainTabBarViewController()], animated: true)
            }, level: [.medium()])
        }, for: .touchUpInside)
        
        registerButton.addAction(UIAction { _ in
            self.showBottomSheet(to: RegisterViewController())
        }, for: .touchUpInside)

    }
    
    override func setupConstraints() {
        
        view.addSubviews(logoIconImage, signInButton, registerButton)
        
        logoIconImage.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(64)
            make.height.width.equalTo(160)
        }
                
        registerButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.logoIconImage.snp.bottom).offset(32)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.registerButton.snp.bottom).offset(16)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }

    }
}
