//
//  SignInViewController.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController {
    
    let onSuccessSignIn: (() -> Void)?
    
    init(onSuccessSignIn: (() -> Void)? = nil) {
        self.onSuccessSignIn = onSuccessSignIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let submitButton = FilledButton(title: "Submit")
    private let faceIDButton = IconButton(icon: AppSVGIcon.faceId.getImage(), size: .init(width: 60, height: 60), iconSize: CGSize(width: 48, height: 48))
    
    private let emailField = FormTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordField = FormTextField(placeholder: "Password", keyboardType: .emailAddress, isPassword: true)
    
    private let viewModel = SingInViewModel()
    private let biometric = BiometricAuth()
    private let disposeBag = DisposeBag()
    
    private var isButtonFaceIDEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        submitButton.addAction(UIAction { _ in
            self.viewModel.signInWithFB {
                self.dismiss(animated: true)
                self.onSuccessSignIn?()
            } onError: { error in
                self.showAlertOK(title: "Error Sign In", message: "Error message: \(error.localizedDescription)")
            } onInvalidEmail: {
                self.showAlertOK(title: "Error Sign In", message: "Enter valid email")
            } onInvalidPassword: {
                self.showAlertOK(title: "Error Sign In", message: "Enter valid password")
            }
        }, for: .touchUpInside)
        
        faceIDButton.addAction(UIAction { _ in
            guard self.isButtonFaceIDEnabled else {
                return
            }
            self.isButtonFaceIDEnabled = false
            self.biometric.authenticate() {
                self.isButtonFaceIDEnabled = true
                self.dismiss(animated: true)
                self.onSuccessSignIn?()
            } onError: { error in
                
            }
        }, for: .touchUpInside)
        
        emailField.field.rx.text
            .compactMap { $0 }
            .filter { $0.isEmpty || $0.count > 4 }
            .subscribe { [weak self] text in
                guard let self = self else {return}
                self.viewModel.email = text
            }
            .disposed(by: disposeBag)
        
        passwordField.field.rx.text
            .compactMap { $0 }
            .filter { $0.isEmpty || $0.count > 4 }
            .subscribe { [weak self] text in
                guard let self = self else {return}
                self.viewModel.password = text
            }
            .disposed(by: disposeBag)
    }
    
    override func setupNavBar() {
        navigationItem.title = "Sign In"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: TextButton(withTitle: "Cancel", size: .init(width: 60, height: 40)) {
            self.dismiss(animated: true)
        })
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addHeader()
        }
    }
    
    override func setupConstraints() {
        view.addSubviews(emailField, passwordField, submitButton, faceIDButton)
        
        emailField.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        passwordField.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.emailField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        submitButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.passwordField.snp.bottom).offset(32)
            make.width.equalTo(300)
            make.height.equalTo(48)
        }
        
        faceIDButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.submitButton.snp.bottom).offset(32)
            make.width.height.equalTo(60)
        }

    }
}
