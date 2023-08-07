//
//  CustomPresentationController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/07.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    var interactionController: UIPercentDrivenInteractiveTransition?
    var backgroundView: UIView!

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerBounds = containerView?.bounds else { return CGRect.zero }
        let presentedSize = CGSize(width: containerBounds.width, height: 205)
        let presentedOrigin = CGPoint(x: 0, y: containerBounds.height - presentedSize.height)
        return CGRect(origin: presentedOrigin, size: presentedSize)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        backgroundView = UIView(frame: containerView?.bounds ?? .zero)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        containerView?.addSubview(backgroundView)

        /// 배경 눌러서 dismiss
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        /// sheet drag해서 dismiss
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 1.0
        }, completion: nil)
    }

    @objc func backgroundTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: presentedViewController.view)

        switch gestureRecognizer.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            let percent = translation.y / frameOfPresentedViewInContainerView.height
            interactionController?.update(percent)
        case .ended, .cancelled:
            let velocity = gestureRecognizer.velocity(in: presentedViewController.view)
            let percent = translation.y / frameOfPresentedViewInContainerView.height

            if percent > 0.5 || velocity.y > 50 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 0
        }, completion: nil)
    }
}
