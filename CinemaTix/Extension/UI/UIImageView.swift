//
//  UIImageView.swift
//  CinemaTix
//
//  Created by Eky on 14/12/23.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadFromUrl(url: URL?, usePlaceholder: Bool = false, isCompressed: Bool = true) {
//        self.kf.indicatorType = .custom(indicator: ImageActivityIndicator())
//        self.kf.indicatorType = .activity
        let placeholder = usePlaceholder ? isPotrait() ? UIImage(named: "imagenotfound2") : UIImage(named: "imagenotfound1") : nil
//        var options: KingfisherOptionsInfo = [
//            .transition(.fade(0.48))
//        ]
//        if isCompressed {
//            options.append(.processor(compressImage()))
//        }
        self.kf.setImage(with: url,
            placeholder: placeholder
//            options: options
        )
    }
    
    private func compressImage(_ percentage: CGFloat = 0.8) -> DownsamplingImageProcessor {
        return DownsamplingImageProcessor(size: CGSize(width: bounds.size.width*percentage, height: bounds.size.height*percentage))
    }
    
    private func isPotrait() -> Bool {
        return bounds.height >= bounds.width
    }
}
