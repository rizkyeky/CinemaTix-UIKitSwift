////
////  GradientView.swift
////  CinemaTix
////
////  Created by Eky on 15/12/23.
////
//
//import UIKit
//
//enum GradientDirection {
//    case topToBottom
//    case bottomToTop
//    case leftToRight
//    case rightToLeft
//}
//
//class GradientView: UIView {
//    
//    private var gradientLayer: CAGradientLayer!
//    
//    private var gradientDirection: GradientDirection = .topToBottom
//    private var colors: [UIColor] = []
//    
//    convenience init(colors: [UIColor], direction: GradientDirection) {
//        self.init()
//        
//        self.colors = colors
//        self.gradientDirection = direction
//        
//        setupGradient()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGradient()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupGradient()
//    }
//    
//    private func setupGradient() {
//        gradientLayer = CAGradientLayer()
//        layer.addSublayer(gradientLayer)
//        updateGradient()
//    }
//    
//    public func updateGradient() {
//        switch gradientDirection {
//        case .topToBottom:
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        case .bottomToTop:
//            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
//            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
//        case .leftToRight:
//            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        case .rightToLeft:
//            gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
//            gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
//        }
//        
//        if colors.count == 2 {
//            gradientLayer.colors = colors
//        } else {
//            gradientLayer.colors = [UIColor.white, UIColor.black]
//        }
//        
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//}
