//
//  UIButton+Category.swift
//  SFWeiBo
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

extension UIButton {
    
    class func creatButton(imageName:String, title:String) -> UIButton {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(10)
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }
}


