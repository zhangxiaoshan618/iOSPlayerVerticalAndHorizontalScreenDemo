//
//  SecondExitFillScreenTransition.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class SecondExitFillScreenTransition: NSObject {
    var playView: SecondPlayView
    
    init(with view: SecondPlayView) {
        self.playView = view
        super.init()
    }
}

extension SecondExitFillScreenTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else { return }
        
        let finaleCenter = transitionContext.containerView.convert(playView.beforeCenter, from: nil)
        print(playView.beforeCenter, finaleCenter)
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        UIView.animate(withDuration: 5, delay: 0.0, options: .layoutSubviews, animations: {[weak self] in
            guard let strongSelf = self else {return}
            fromView.transform = CGAffineTransform.identity
            fromView.center = finaleCenter
            fromView.bounds = strongSelf.playView.beforeBounds
        }) {[weak self] (_) in
            guard let strongSelf = self else {return}
            strongSelf.playView.frame = strongSelf.playView.frame
            strongSelf.playView.parentView?.addSubview(strongSelf.playView)
            print("----",self?.playView, self?.playView.parentView, self?.playView.parentView?.subviews)
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        
    }
}
