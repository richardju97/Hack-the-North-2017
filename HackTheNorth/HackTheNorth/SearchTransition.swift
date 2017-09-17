//
//  SearchTransition.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

fileprivate let kTransitionDuration: TimeInterval = 0.2

class SearchTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var originalFrame: CGRect = .zero
    var searchTextFieldView: UIView?

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.viewController(forKey: .to), let source = transitionContext.viewController(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView
        let initialFrame = originalFrame
        let finalFrame = transitionContext.finalFrame(for: destination)

        guard let snapshot = destination.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        snapshot.frame = transitionContext.finalFrame(for: destination)
        snapshot.frame.origin.y = initialFrame.origin.y

        containerView.addSubview(destination.view)
        containerView.addSubview(snapshot)
        destination.view.isHidden = true

        UIView.animate(withDuration: kTransitionDuration, animations: {
            if let searchTextFieldView = self.searchTextFieldView {
                searchTextFieldView.transform = CGAffineTransform(translationX: 0, y: -(initialFrame.origin.y - 30))
            }
        }) { completed in
            destination.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if let destination = destination as? SearchVideoViewController {
                destination.searchTextField.becomeFirstResponder()
            }
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kTransitionDuration
    }
}

class SearchPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var originalFrame: CGRect = .zero
    var searchTextFieldView: UIView?

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.viewController(forKey: .to), let source = transitionContext.viewController(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView
        let initialFrame = originalFrame
        let finalFrame = transitionContext.finalFrame(for: destination)

        guard let snapshot = destination.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        snapshot.frame = transitionContext.finalFrame(for: destination)
        snapshot.frame.origin.y = initialFrame.origin.y

        containerView.addSubview(destination.view)
        containerView.addSubview(snapshot)
        destination.view.isHidden = true

        UIView.animate(withDuration: kTransitionDuration, animations: {
            if let searchView = self.searchTextFieldView {
                searchView.transform = CGAffineTransform.identity
            }
        }) { completed in
            destination.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if let destination = destination as? SearchVideoViewController {
                destination.searchTextField.becomeFirstResponder()
            }
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kTransitionDuration
    }
}
