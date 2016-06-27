//
//  UIBarButtonItem+Category.swift
//  SFWeiBo
//
//  Created by mac on 16/3/26.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import Foundation
import UIKit

//定义分类(给UIBarButtonItem扩充方法)
extension UIBarButtonItem {
    
    //在func前面加上class,就相当于OC中的+,类方法
    class func creatBarButtonItem(imageName:String, target:AnyObject?, action:Selector) -> UIBarButtonItem {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    convenience init(imageName:String, target: AnyObject?, action: String?)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        if action != nil
        {
            // 如果是自己封装一个按钮, 最好传入字符串, 然后再将字符串包装为Selector
            btn.addTarget(target, action: Selector(action!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        btn.sizeToFit()
        self.init(customView: btn)
    }

}