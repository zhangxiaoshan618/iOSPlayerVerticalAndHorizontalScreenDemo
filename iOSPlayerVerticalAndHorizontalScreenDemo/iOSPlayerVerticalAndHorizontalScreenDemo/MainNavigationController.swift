//
//  MainNavigationController.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return topViewController?.prefersStatusBarHidden ?? false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .allButUpsideDown
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

}
