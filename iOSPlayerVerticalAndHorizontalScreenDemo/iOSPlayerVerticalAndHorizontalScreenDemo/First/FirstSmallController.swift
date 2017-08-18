//
//  FirstSmallController.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class FirstSmallController: UIViewController {
    
    var portraitTransform: CGAffineTransform?
    var landscapeRightTransform: CGAffineTransform?
    var landscapeLeftTransform: CGAffineTransform?

    lazy var playView: FirstPlayView = {
        let playView = FirstPlayView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        let tap = UITapGestureRecognizer(target: self, action: #selector(FirstSmallController.handleTapGesture(sender:)))
        playView.addGestureRecognizer(tap)
        playView.translatesAutoresizingMaskIntoConstraints = false
        return playView
    }()
    
    weak var controller: FirstFullScreenController?
    
    lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        return view
    }()
    
    lazy var label: UIView = {
        let label = UILabel(frame: CGRect(x: 100, y: 400, width: 300, height: 50))
        label.text = "这是先做动画，后做无动画的modal"
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 100, y: 500, width: 300, height: 50))
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(FirstSmallController.backBtnClick(with:)), for: .touchUpInside)
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
    
    override func loadView() {
        super.loadView()
        view.backgroundColor =  UIColor.white
        
        contentView.addSubview(playView)
        
        view.addSubview(label)
        view.addSubview(backBtn)
        view.addSubview(contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(FirstSmallController.deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceOrientationDidChange() {
        if playView.state == .small {
            switch UIDevice.current.orientation {
            case .portrait:
                break
            case .landscapeLeft:
                present(to: FirstLandscapeRightController())
            case .landscapeRight:
                present(to: FirstLandscapeLeftController())
            default:
                break
            }
        }else if playView.state == .fullScreen {
            switch UIDevice.current.orientation {
            case .portrait:
                dimiss()
            case .landscapeLeft:
                contentView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            case .landscapeRight:
                contentView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            default:
                break
            }
        }
        
        
        
    }
    
    func backBtnClick(with sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        print("First-ViewWillAppear")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("First-ViewDidLayoutSubviews")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("First-ViewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("First-ViewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("First-ViewDidDisappear")
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let size = super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        print("First-size, size = ", size)
        return size
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("First-viewWillTransition")
    }
    
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
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
        
        present(to: FirstLandscapeRightController())
    }
    
    func present(to controller: FirstFullScreenController) {
        // 允许 application 横屏
        isAllowLandscape = true
        
        self.controller = controller
        playView.state = .animating
        playView.beforeFrame = contentView.frame
        playView.beforeBounds = contentView.bounds
        playView.beforeCenter = contentView.center
        portraitTransform = contentView.transform
        
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .layoutSubviews, animations: {[weak self] in
            
            self?.contentView.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
            self?.contentView.center = self!.view.center
            
            if controller is FirstLandscapeLeftController {
                self?.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            }else {
                self?.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            }
            
        }) {[weak self] (_) in
            
            guard let strongSelf = self else {return}
            
            self?.playView.state = .fullScreen

            self?.present(controller, animated: false, completion: {
                self?.playView.removeFromSuperview()
                self?.controller?.view.addSubview(self!.playView)
                // 两种方式都可以
                // 方式一：将当前控制器的view插入到 横屏view的下方
//                controller.view.superview?.insertSubview(strongSelf.view, belowSubview: controller.view)
                // 方式二：.overFullScreen的实际效果
                if let keyWindow = UIApplication.shared.keyWindow,let rootViewController = UIApplication.shared.keyWindow?.rootViewController, let containerView = controller.view.superview  {
                    keyWindow.insertSubview(rootViewController.view, belowSubview: containerView)
                }
            })
            
        }

    }
    
    
    
    func exitFullScreen() {
        if playView.state != .fullScreen {
            return
        }
        dimiss()
    }
    
    func dimiss() {
        
        contentView.addSubview(self.playView)
        self.controller?.dismiss(animated: false) {[weak self] in
            isAllowLandscape = false
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .layoutSubviews, animations: {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.contentView.transform = CGAffineTransform.identity //self!.contentView.transform.rotated(by: CGFloat(-Double.pi / 2))
                strongSelf.contentView.bounds = strongSelf.playView.beforeBounds
                strongSelf.contentView.center = strongSelf.playView.beforeCenter
            }) {[weak self] (_) in
                self?.playView.state = .small
            }
        }
    }

}
