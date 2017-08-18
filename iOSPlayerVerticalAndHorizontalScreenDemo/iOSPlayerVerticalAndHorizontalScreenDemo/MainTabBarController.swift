//
//  MainTabBarController.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func loadView() {
        super.loadView()
        
        let firstVC = ViewController()
        firstVC.title = "非自定义转场动画"
        firstVC.tabBarItem.image = #imageLiteral(resourceName: "activity")
        let firstNVC = MainNavigationController(rootViewController: firstVC)
        
        let thiredVC = ViewController()
        thiredVC.title = "自定义转场动画"
        thiredVC.tabBarItem.image = #imageLiteral(resourceName: "barrage")
        let thiredNVC = MainNavigationController(rootViewController: thiredVC)
        
        self.addChildViewController(firstNVC)
        self.addChildViewController(thiredNVC)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Tabbar - WillAppear",view.frame)
        // 因为 presented 完成后，控制器的view的frame会错乱，需要每次将要展现的时候强制设置一下
        view.frame = UIScreen.main.bounds
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.prefersStatusBarHidden ?? false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return selectedViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
    
    override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

}
