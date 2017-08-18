//
//  SecondSmallController.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class SecondSmallController: UIViewController {
    
    weak var controller: SecondFullScreenController?

    lazy var playView:SecondPlayView = {
        let playView = SecondPlayView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        playView.addGestureRecognizer(tap)
        
        return playView
    }()
    
    lazy var label: UIView = {
        let label = UILabel(frame: CGRect(x: 0, y: 400, width: UIScreen.main.bounds.width, height: 50))
        label.text = "这是自定义转场动画的方式"
        
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 500, width: UIScreen.main.bounds.width, height: 50))
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(SecondSmallController.backBtnClick(with:)), for: .touchUpInside)
        return btn
    }()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    
    func backBtnClick(with sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapGesture(sender: UITapGestureRecognizer) {
        
        switch playView.state {
        case .small:
            enterFullscreen()
        case .fullScreen:
            exitFullScreen()
        case .animating:
            break
        }
    }
    
    func enterFullscreen() {
        if playView.state != .small {
            return
        }
        
        let controller = SecondLandscapeRightController()
        present(to: controller)
    }
    
    func exitFullScreen() {
        if playView.state != .fullScreen {
            return
        }
        playView.state = .animating
        controller?.dismiss(animated: true) {[weak self] in
            isAllowLandscape = false
            self?.playView.state = .small
        } 
    }
    
    func present(to controller: SecondFullScreenController) {
        isAllowLandscape = true
        
        playView.state = .animating
        playView.beforeBounds = playView.bounds
        playView.beforeCenter = playView.center
        playView.parentView = playView.superview
        
        
        controller.playView = playView
        controller.modalPresentationStyle = .fullScreen
        controller.transitioningDelegate = self
        present(controller, animated: true) {[weak self] in
            self?.playView.state = .fullScreen
        }
        self.controller = controller
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(backBtn)
        view.addSubview(label)
        view.addSubview(playView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SecondSmallController.deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceOrientationDidChange() {
        if playView.state != .small {
            return
        }
        
        switch UIDevice.current.orientation {
        case .portrait:
            break
        case .landscapeLeft:
            let controller = SecondLandscapeRightController()
            present(to: controller)
        case .landscapeRight:
            let controller = SecondLandscapeLeftController()
            present(to: controller)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        print("WillAppear",view.frame)
        // 因为 presented 完成后，控制器的view的frame会错乱，需要每次将要展现的时候强制设置一下(只需在最外层的controller中设置即可)
        //view.frame = UIScreen.main.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DidAppear",view.frame)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("WillLayoutSubviews", view.frame)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("DidLayoutSubviews", view.frame)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("WillDisappear", view.frame)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("DidDisappear", view.frame)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SecondSmallController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SecondEnterFullScreenTransition(with: playView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SecondExitFillScreenTransition(with: playView)
    }
}
