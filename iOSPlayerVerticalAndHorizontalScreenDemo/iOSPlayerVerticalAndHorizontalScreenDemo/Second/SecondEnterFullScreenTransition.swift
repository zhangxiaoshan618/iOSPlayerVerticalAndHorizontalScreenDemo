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
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to), let toController = transitionContext.viewController(forKey: .to) else {
            return
        }
        // 计算toView的初始位置
        let initialCenter = transitionContext.containerView.convert(playView.beforeCenter, from: playView)
        
        transitionContext.containerView.addSubview(toView)
        // 将toView的 位置变为初始位置，准备动画
        toView.addSubview(playView)
        toView.bounds = playView.beforeBounds
        toView.center = initialCenter
        // 根据屏幕方向的不同选择不同的角度
        if toController.isKind(of: SecondLandscapeLeftController.self) {
            toView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }else {
            toView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
            // 将 toView 从设置的初始位置回复到正常位置
            toView.transform = CGAffineTransform.identity
            toView.bounds = transitionContext.containerView.bounds
            toView.center = transitionContext.containerView.center
            
        }) { (_) in
            // 动画完成后再次设置终点状态，防止动画被打断造成BUG
            toView.transform = CGAffineTransform.identity
            toView.bounds = transitionContext.containerView.bounds
            toView.center = transitionContext.containerView.center
            transitionContext.completeTransition(true)
        }
    }
}
