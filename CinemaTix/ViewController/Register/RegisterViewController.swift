//
//  RegisterViewController.swift
//  CinemaTix
//
//  Created by Eky on 18/12/23.
//

import UIKit
import RxSwift

class RegisterViewController: BaseViewController {
    
    let onSuccessSignIn: (() -> Void)?
    
    init(onSuccessSignIn: (() -> Void)? = nil) {
        self.onSuccessSignIn = onSuccessSignIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let submitButton = FilledButton(title: "Submit")
    
    private let emailField = FormTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let usernameField = FormTextField(placeholder: "Username", keyboardType: .alphabet)
    private let passwordField = FormTextField(placeholder: "Password", keyboardType: .emailAddress, isPassword: true)
    
    private let viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.addAction(UIAction { _ in
            self.viewModel.registerWithFB {
                self.dismiss(animated: true)
                self.onSuccessSignIn?()
            } onError: { error in
                self.showAlertOK(title: "Error Sign In", message: "Error message: \(error.localizedDescription)")
            }
        }, for: .touchUpInside)
        
        let disposeBag = DisposeBag()
        
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
        navigationItem.title = "Register"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: TextButton(withTitle: "Cancel", size: .init(width: 60, height: 40)) {
            self.dismiss(animated: true)
        })
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addHeader()
        }
    }
    
    override func setupConstraints() {
        view.addSubviews(emailField, passwordField, submitButton)
        
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
    }

}
