//
//  SignInOptionViewController.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit

class SignInOptionsSheetViewController: BaseViewController {
    
    let onTapSubmit: (() -> Void)?
    
    init(onTapSubmit: (() -> Void)? = nil) {
        self.onTapSubmit = onTapSubmit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let appleButton = FilledButton(title: "Sign In with Apple", icon: AppSVGIcon.apple.getImage(), iconSize: CGSize(width: 32, height: 32))
    private let googleButton = FilledButton(title: "Sign In with Google", icon: AppSVGIcon.google.getImage(), iconSize: CGSize(width: 32, height: 32))
    private let emailButton = FilledButton(title: "Sign In with Email", icon: AppSVGIcon.email.getImage(), iconSize: CGSize(width: 32, height: 32))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailButton.addAction(UIAction { _ in
            self.present(UINavigationController(rootViewController: SignInViewController {
                self.dismiss(animated: true)
                self.onTapSubmit?()
            }), animated: true, completion: nil)
        }, for: .touchUpInside)
    }
    
    override func setupNavBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addHeader()
        }
    }
    
    override func setupConstraints() {
        view.addSubviews(appleButton, googleButton, emailButton)
        
        appleButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
        googleButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.appleButton.snp.bottom).offset(16)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
        emailButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.googleButton.snp.bottom).offset(16)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
        
    }
}
