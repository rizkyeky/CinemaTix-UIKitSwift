//
//  Indicator.swift
//  CinemaTix
//
//  Created by Eky on 15/12/23.
//

import UIKit
import Kingfisher

struct ImageActivityIndicator: Indicator {
    
    let view: Kingfisher.IndicatorView = UIView()
    
    private let activity = UIActivityIndicatorView(style: .large)
    
    func startAnimatingView() {
        activity.startAnimating()
        view.isHidden = false
    }
    func stopAnimatingView() {
        activity.stopAnimating()
        view.isHidden = true
    }
    
    init() {
        view.backgroundColor = .systemFill
        activity.color = .systemBackground
        view.addSubview(activity)
        activity.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.height.width.equalTo(60)
        }
    }
}
