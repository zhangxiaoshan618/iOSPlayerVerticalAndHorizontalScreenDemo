//
//  ViewController.swift
//  iOSPlayerVerticalAndHorizontalScreenDemo
//
//  Created by 张晓珊 on 2017/8/15.
//  Copyright © 2017年 张晓珊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 50))
        btn.setTitle("点击进入播放页面", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(ViewController.nextBtnClick(with:)), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(nextBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func nextBtnClick(with sender: UIButton) {
        if let selectedIndex = tabBarController?.selectedIndex {
            switch selectedIndex {
            case 0:
                let firstController = FirstSmallController()
                navigationController?.pushViewController(firstController, animated: true)
                
            case 1:
                let secondController = SecondSmallController()
                navigationController?.pushViewController(secondController, animated: true)
                
            default:
                break
            }
        }
    }


}

