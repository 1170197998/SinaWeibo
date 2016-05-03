//
//  PopoverPresentationController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/27.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class PopoverPresentationController: UIPresentationController {

    //定义一个属性保存菜单的大小
    var presentFrame = CGRectZero
    
    //必须要写的一个初始化方法,用于创建负责转场动画的对象
    //presentedViewController: 被展现的控制器
    //presentingViewController: 发起的控制器,xcode6是nil,xcode7是野指针
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        print(presentedViewController)
        //print(presentingViewController) //野指针,会崩溃
    }
    
    // MARK: - 重写containerViewWillLayoutSubviews
    //即将布局转场子视图时调用
    override func containerViewWillLayoutSubviews() {
        
        //修改弹出视图的大小
        //containerView: 容器视图
        //presentedView: 被展现的视图
        
        if presentFrame == CGRectZero {
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        } else {
            presentedView()?.frame = presentFrame
        }
        
        //在容器视图上添加一个蒙版,插入到展现视图的下面
        //因为展现视图和蒙版都在同一个视图上,而后添加的会覆盖先添加的
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    // MARK: - 懒加载一个蒙版
    private lazy var coverView:UIView = {
       
        //创建蒙版view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        //为蒙版view添加一个监听,点击蒙版的时候,转场消失
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        return view
    }()
    
    func close() {
        //把当前弹出的控制器dismiss
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
  