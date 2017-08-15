//
//  FirstPlayView.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

enum PlayViewState {
    case small
    case animating
    case fullScreen
}

class FirstPlayView: UIView {

    var vConstraints: [NSLayoutConstraint]?
    var hConstraints: [NSLayoutConstraint]?
    
    weak var parentView: UIView?
    var beforeFrame: CGRect = CGRect.zero
    var state: PlayViewState = .small
    var beforeBounds: CGRect = CGRect.zero
    var beforeCenter:CGPoint = CGPoint.zero
    
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        addSubview(imageView)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[image]-0-|", options: [], metrics: nil, views: ["image": imageView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: [], metrics: nil, views: ["image": imageView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        if let v = vConstraints, let h = hConstraints {
            NSLayoutConstraint.deactivate(v)
            NSLayoutConstraint.deactivate(h)
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let _ = self.superview {
            self.vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[play]-0-|", options: [], metrics: nil, views: ["play": self])
            self.hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[play]-0-|", options: [], metrics: nil, views: ["play": self])
            NSLayoutConstraint.activate(vConstraints!)
            NSLayoutConstraint.activate(hConstraints!)
        }
    }

}
