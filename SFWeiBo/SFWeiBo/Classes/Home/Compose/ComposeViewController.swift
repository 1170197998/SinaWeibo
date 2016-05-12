//
//  ComposeViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupNav()
        setupInputView()
    }
    
    ///初始化输入框
    private func setupInputView() {
        
    }
    
    ///初始化导航条
    private func setupNav() {
        
        //添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposeViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposeViewController.sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        
        //添加中间视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        let label1 = UILabel()
        label1.font = UIFont.systemFontOfSize(15)
        label1.text = "发送微博"
        label1.sizeToFit()
        titleView.addSubview(label1)
        let label2 = UILabel()
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        label2.text = UserAccount.loadAccount()?.screen_name
        label2.sizeToFit()
        titleView.addSubview(label2)
        label1.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: titleView, size: nil)
        label2.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: titleView, size: nil)
        navigationItem.titleView = titleView
    }


    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendStatus() {
        
    }
}
