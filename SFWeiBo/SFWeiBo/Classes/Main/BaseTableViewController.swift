//
//  BaseTableViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorViewDelegate {

    //定义一个变量,保存用户是否登录
    var userLogin = UserAccount.userLogin()
    //定义属性保存未登录界面
    var visitorView: VisitorView?
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 创建未登录界面
    private func setupVisitorView() {
        
        //初始化未登录界面
        let customView = VisitorView()
        customView.delegate = self
        view = customView
        visitorView = customView
        
        //设置导航控制器的登录注册按钮
        //已经在AppDelegate中指定完毕
        //navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerButtonWillClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginButotnWillClick")
    }
    
    // MARK: - VisitorViewDelegate
    func loginButotnWillClick() {
        print(__FUNCTION__)
        
        //弹出登录界面
        let oauthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVC)
        presentViewController(nav, animated: true, completion: nil)
    }
    func registerButtonWillClick() {
        print(UserAccount.loadAccount())
    }
}
