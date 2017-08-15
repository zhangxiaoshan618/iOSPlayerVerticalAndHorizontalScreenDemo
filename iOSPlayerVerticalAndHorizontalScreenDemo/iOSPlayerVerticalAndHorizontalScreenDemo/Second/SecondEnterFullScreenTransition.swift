//
//  SecondEnterFullScreenTransition.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class SecondEnterFullScreenTransition: NSObject {
    var playView: SecondPlayView
    
    init(with view: SecondPlayView) {
        self.playView = view
        super.init()
        
        
    }
}

extension SecondEnterFullScreenTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to), let toController = transitionContext.viewController(forKey: .to), let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        let initialCenter = transitionContext.containerView.convert(playView.beforeCenter, from: playView)
        
        transitionContext.containerView.addSubview(toView)
        toView.addSubview(playView)
        toView.bounds = playView.beforeBounds
        toView.center = initialCenter
        toView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        
        UIView.animate(withDuration: 5, delay: 0, options: .layoutSubviews, animations: {
            toView.bounds = transitionContext.containerView.bounds
            toView.center = transitionContext.containerView.center
            toView.transform = CGAffineTransform.identity
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
