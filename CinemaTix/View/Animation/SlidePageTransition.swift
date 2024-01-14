//
//  SlidePageTransition.swift
//  CinemaTix
//
//  Created by Eky on 19/12/23.
//
import UIKit

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionDirection: TransitionDirection = .leftToRight
    
    enum TransitionDirection {
        case leftToRight
        case rightToLeft
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // Set the duration of the animation
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        // Set the initial position of the 'to' view controller offscreen
        var fromViewFinalFrame = fromVC.view.frame
        var toViewInitialFrame = toVC.view.frame
        
        switch transitionDirection {
        case .leftToRight:
            fromViewFinalFrame.origin.x = -fromVC.view.frame.width
            toViewInitialFrame.origin.x = toVC.view.frame.width
        case .rightToLeft:
            fromViewFinalFrame.origin.x = fromVC.view.frame.width
            toViewInitialFrame.origin.x = -toVC.view.frame.width
        }
        
        toVC.view.frame = toViewInitialFrame
        containerView.addSubview(toVC.view)
        
        // Animate the transition
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = fromViewFinalFrame
            toVC.view.frame = fromVC.view.frame
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}
