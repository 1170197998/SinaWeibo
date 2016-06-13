//
//  AppDelegate.swift
//  SFWeiBo
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

//切换控制器通知
let SFSwitchRootViewController = "SFSwitchRootViewController"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.switchRootViewController(_:)), name: SFSwitchRootViewController, object: nil)
        
        //设置导航条和工具条的外观
        //在这里设置程序-进来就执行,全局有效
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        
        //1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        //2.创建根控制器
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
        print(isNewupdate())
        
        return true
    }
    
    //移除通知(相当于OC中的dealloc)
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - 实现通知方法
    func switchRootViewController(notify: NSNotification) {
        
        if notify.object as! Bool {
            window?.rootViewController = MainViewController()
        } else {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    
    //MARK: - 获取默认界面
    private func defaultController() -> UIViewController {
        
        //检查是否登录
        if UserAccount.userLogin() {
            return isNewupdate() ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    private func isNewupdate() -> Bool{
        
        //获取当前版本号(版本号是字符串)
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        //获取以前的版本号(从沙盒中获取)
        //?? : 如果没有值,就让他等于空("")
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""

        //比较当前版本号和以前版本号
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            //存储当前的版本到沙盒
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            //获取到的当前版本 > 之前的版本 = 有新版本
            return true
        }
        //获取到的当前版本 <= 之前的版本 = 没有新版本
        return false
    }

}

