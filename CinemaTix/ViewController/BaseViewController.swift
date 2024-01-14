//
//  Base.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        setupNavBar()
        setupConstraints()
    }
    
    internal func setupConstraints() {
        
    }
    
    internal func setupNavBar() {
        
    }
    
    func showBottomSheet(to vc: UIViewController, completion: (() -> Void)? = nil, level: [UISheetPresentationController.Detent] = [.large()]) {
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            navController.sheetPresentationController?.detents = level
        }
        present(navController, animated: true, completion: completion)
    }
    
    func showAlertOKCancel(title: String, message: String, onTapOK: (() -> Void)? = nil, onTapCancel: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true)
            onTapOK?()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
            onTapCancel?()
        }))
        
        present(alert, animated: true, completion: completion)
    }
    
    func showAlertOK(title: String, message: String, onTapOK: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true)
            onTapOK?()
        }))
        
        present(alert, animated: true, completion: completion)
    }

}
