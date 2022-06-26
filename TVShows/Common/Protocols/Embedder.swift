//
//  Embedder.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit

protocol Embedder where Self: UIViewController {}

extension Embedder {
    func embed(_ viewController: UIViewController, into view: UIView) {
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.beginAppearanceTransition(true, animated: true)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.view.activateSuperviewHuggingConstraints()
        viewController.endAppearanceTransition()
    }

    func unembed(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    func transition(from fromViewController: UIViewController?,
                    to toViewController: UIViewController,
                    into view: UIView,
                    animated: Bool = true) {
        guard let fromViewController = fromViewController else {
            embed(toViewController, into: view)
            return
        }
        if animated {
            toViewController.view.alpha = 0
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                fromViewController.view.alpha = 0
                self.unembed(viewController: fromViewController)
                self.embed(toViewController, into: view)
                toViewController.view.alpha = 1
            }
        } else {
            unembed(viewController: fromViewController)
            embed(toViewController, into: view)
        }
    }
    
}
