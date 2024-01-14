//
//  LaunchViewController.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import UIKit
import Lottie
import SnapKit
import IQKeyboardManagerSwift
import FirebaseCore
#if DEBUG
import netfox
#endif

class LaunchViewController: BaseViewController {
    
    private let animLottie: LottieAnimationView = {
        let anim = LottieAnimationView(name: "AnimTicket")
        anim.frame = .init(x: 0, y: 0, width: 200, height: 200)
        anim.loopMode = .loop
        return anim
    }()
    
    private let logoIconImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Icon"))
        image.frame = .init(x: 0, y: 0, width: 160, height: 160)
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animLottie.play()
        loadLibraries()

        UIView.animate(withDuration: 0.48, delay: 0, options: .curveEaseOut, animations: {
            self.animLottie.alpha = 1.0
            self.logoIconImage.transform = CGAffineTransform(translationX: 0, y: -200)
        }) { _ in
            self.didCompleteAnim()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animLottie.stop()
    }
    
    override func setupConstraints() {
        
        view.addSubviews(logoIconImage, animLottie)
        
        logoIconImage.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).inset(20)
        }
        animLottie.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view)
            make.width.height.equalTo(200)
        }
    }
    
    private func loadLibraries() {
#if DEBUG
        NFX.sharedInstance().start()
#endif
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            let audio = Audio()
            audio.loadNotification()
            audio.playAudio()
        }
    }
    
    private func didCompleteAnim() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let authVM = AuthViewModel()
            authVM.checkActiveUser { user in
                let firstVC: UIViewController
                if let _ = user {
                    firstVC = MainTabBarViewController()
                } else {
                    firstVC = WelcomeViewController()
                }
                self.navigationController?.setViewControllers([firstVC], animated: true)
            } onError: { error in
                self.showAlertOK(title: "Error", message: "User is not found", onTapOK: {
                    self.navigationController?.setViewControllers([WelcomeViewController()], animated: true)
                })
            }
        }
    }
}
