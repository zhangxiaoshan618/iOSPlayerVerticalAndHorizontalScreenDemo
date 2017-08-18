//
//  SecondFullScreenController.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class SecondFullScreenController: UIViewController {
    
    var playView: SecondPlayView?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(SecondFullScreenController.deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceOrientationDidChange() {
        if playView?.state != .fullScreen {
            return
        }
        
        if let playView = self.playView {
            switch UIDevice.current.orientation {
            case .portrait:
                playView.state = .animating
                dismiss(animated: true) {
                    isAllowLandscape = false
                    playView.state = .small
                }
            default:
                break
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let play = playView {
            play.frame = self.view.bounds
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
