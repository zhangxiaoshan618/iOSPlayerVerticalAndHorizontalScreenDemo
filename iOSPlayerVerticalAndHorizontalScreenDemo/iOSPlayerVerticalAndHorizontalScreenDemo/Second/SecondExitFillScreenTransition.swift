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
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else { return }
        
        // 计算 fromView的最终位置
        let finaleCenter = transitionContext.containerView.convert(playView.beforeCenter, from: nil)

        // 将 toView 插入fromView的下面，否则动画过程中不会显示toView
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .layoutSubviews, animations: {[weak self] in
            
            guard let strongSelf = self else {return}
            // 让 fromView 返回playView的初始值
            fromView.transform = CGAffineTransform.identity
            fromView.center = finaleCenter
            fromView.bounds = strongSelf.playView.beforeBounds
            
        }) {[weak self] (_) in
            guard let strongSelf = self else {return}
            // 动画完成后再次设置终点状态，防止动画被打断造成BUG
            fromView.transform = CGAffineTransform.identity
            fromView.center = finaleCenter
            fromView.bounds = strongSelf.playView.beforeBounds
            
            // 动画完成后，将playView添加到竖屏界面上
            strongSelf.playView.frame = strongSelf.playView.frame
            strongSelf.playView.parentView?.addSubview(strongSelf.playView)
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
            
        }
    }
}
