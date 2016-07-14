//
//  MainViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加所有子控制器
        addChildViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //从iOS7开始就不推荐在viewDidload中设置控件frame
        //添加 加号 按钮
        setupComposeButton()
    }
    
    // MARK: - 中间按钮的监听事件
    // 监听按钮点击的方法不能是私有方法(不能加private),因为是有运行循环触发的
    func composeButtonClick() {
        let vc = ComposeViewController()
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: - 添加 加号 按钮
    private func setupComposeButton() {
        
        //添加 加号 按钮
        tabBar.addSubview(composeButton)
        
        //调整 加号 按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat((viewControllers?.count)!)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        
        //第一个参数:frame的大小
        //第二个参数:x方向偏移的大小
        //第三个参数:y方向偏移的大小
        composeButton.frame = CGRectOffset(rect, 2 * width, 0)
    }
    
    // MARK: - 添加所有子控制器
    private func addChildViewControllers() {
        //1.获取json数据
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        //2.通过文件路径创建NSData
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do {
                //这里面放置有可能发生异常的代码
                //3.序列化json数据  -->  Array
                //try :发生异常会调到 catch 中继续执行
                //try! : 发生异常直接崩溃
                let dictArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                //print(dictArray)
                
                //4.遍历数组,动态创建控制器和设置数据
                //在Swift中,如果需要遍历一个数组,必须明确数据的类型
                for dict in dictArray as! [[String:String]] {
                    
                    //addChildViewController下面的这个方法要求必须有参数,,但是字典的返回值是可选类型
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
                //如果服务器返回来数据,就从服务器加载数据(执行do里面的代码)加载控制器
                //如果服务器没有返回数据(异常情况,就本地代码加载控制器,执行catch里面的代码)
                
            } catch {
                //发生异常会执行的代码
                print(error)
                //添加子控制器(从本地加载创建控制器)
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
        }
    }
    
    // MARK: - 初始化子控制器(控制器名字,标题,图片) <传控制器的名字代替传控制器>
    //    private func addChildViewController(childController: UIViewController, title:String, imageName:String) {
    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        
        //0.动态获取命名空间(CFBundleExecutable这个键对应的值就是项目名称,也就是命名空间)
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        //1.将字符串转化为类
        //默认情况下,命名空间就是项目名称,但是命名空间是可以修改的
        let cls:AnyClass? = NSClassFromString(nameSpace + "." + childControllerName) //SFWeiBo.是命名空间
        //2.通过类创建对象
        //2.1将anyClass转换为指定的类型
        let viewControllerCls = cls as! UIViewController.Type
        
        //2.2通过class创建对象
        let vc = viewControllerCls.init()
        
        //1设置tabbar对应的按钮数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "highlighted")
        vc.title = title
        
        //2.给首页包装导航条
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        //3.将导航控制器添加到当前控制器
        addChildViewController(nav)
    }
    
    // MARK: - 懒加载控件
    private lazy var composeButton:UIButton = {
        
        let button = UIButton()
        
        //设置前景图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        //设置前景图片
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState:UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        //添加监听事件
        button.addTarget(self, action: #selector(MainViewController.composeButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
}
