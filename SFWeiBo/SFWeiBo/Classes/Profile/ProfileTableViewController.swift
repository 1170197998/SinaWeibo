//
//  ProfileTableViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1. 如果没有登录,就设置未登录界面信息
        if !userLogin {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友",style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ProfileTableViewController.leftBarButtonItemClick))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "设置",style: UIBarButtonItemStyle.Plain, target:self, action:#selector(ProfileTableViewController.rightBarButtonItemClick))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
    }
    
    func leftBarButtonItemClick() {
        let vc = AddFriendViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightBarButtonItemClick() {
        let vc = SetupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
