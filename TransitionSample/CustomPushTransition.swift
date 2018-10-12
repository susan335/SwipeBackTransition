//
//  CustomPushTransition.swift
//  CustomPushTransition
//
//  Created by Yohta Watanave on 2018/10/12.
//  Copyright © 2018 watanave. All rights reserved.
//

import UIKit

class CustomPushTransition: NSObject {
    
    private var attachViewController: UIViewController?
    private let transitionDelegate = TransitioningDelegate()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let gestureDelegate = GestureRecognizerDelegate()
    
    init(attachViewController: UIViewController) {
        super.init()
        
        self.attachViewController = attachViewController
        attachViewController.transitioningDelegate = self.transitionDelegate
        attachViewController.view.addGestureRecognizer(self.panGestureRecognizer)
        self.panGestureRecognizer.delegate = self.gestureDelegate
        self.panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let interactiveTransition = self.transitionDelegate.interactiveTransition
        
        let translation = sender.translation(in: sender.view!)
        let ratio = translation.x / sender.view!.frame.width
        switch sender.state {
        case .began:
            self.attachViewController?.dismiss(animated: true, completion: nil)
        case .changed:
            interactiveTransition?.update(ratio)
        case .cancelled:
            interactiveTransition?.cancel()
        case .ended:
            if ratio > 0.3 {
                interactiveTransition?.finish()
            }
            else {
                interactiveTransition?.cancel()
            }
        default: break
        }
    }
    
    private class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
        
        let animator = Animator()
        var interactiveTransition: UIPercentDrivenInteractiveTransition?
        
        deinit {
            print(#function)
        }
        
        func animationController(forPresented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            animator.presenting = true
            return animator
        }
        
        func animationController(forDismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            animator.presenting = false
            return animator
        }
        
        func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            self.interactiveTransition = UIPercentDrivenInteractiveTransition()
            self.interactiveTransition?.completionSpeed = 0.99
            return self.interactiveTransition
        }
    }
    
    private class GestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
        
        deinit {
            print(#function)
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let view = gestureRecognizer.view else { return false }
            guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
            let translation = panGestureRecognizer.translation(in: view)
            if translation.x < 0 { return false }
            return abs(translation.x) > abs(translation.y)
        }
    }
    
    private class Animator: NSObject, UIViewControllerAnimatedTransitioning {
        
        static let moveDistance: CGFloat = 70.0
        var presenting = false
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.25
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromViewController = transitionContext.viewController(forKey: .from),
                let toViewController = transitionContext.viewController(forKey: .to) else {
                    return
            }
            
            if presenting {
                presentTransition(transitionContext: transitionContext, toView: toViewController.view, fromView: fromViewController.view)
            } else {
                dismissTransition(transitionContext: transitionContext, toView: toViewController.view, fromView: fromViewController.view)
            }
        }
        
        func presentTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
            let containerView = transitionContext.containerView
            containerView.insertSubview(toView, aboveSubview: fromView)
            
            toView.frame = containerView.frame.offsetBy(dx: containerView.frame.size.width, dy: 0)
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    fromView.frame = fromView.frame.offsetBy(dx: -Animator.moveDistance, dy: 0)
                    fromView.alpha = 0.7
                    
                    toView.frame = containerView.frame
                },
                completion: { (finished)  in
                    fromView.frame = fromView.frame.offsetBy(dx: Animator.moveDistance, dy: 0)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
        }
        
        func dismissTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {
            let containerView = transitionContext.containerView
            containerView.insertSubview(toView, belowSubview: fromView)
            
            toView.frame = containerView.frame.offsetBy(dx: -Animator.moveDistance, dy: 0)
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    fromView.frame = fromView.frame.offsetBy(dx: containerView.frame.size.width - 20, dy: 0)
                    toView.frame = toView.frame.offsetBy(dx: Animator.moveDistance, dy: 0)
                    toView.alpha = 1.0
                },
                completion: { (finished)  in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
        }
    }

}
