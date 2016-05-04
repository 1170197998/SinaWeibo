//
//  UIColor+Category.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/5/4.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

extension UIColor
{
    class func randomColor() -> UIColor {
        return UIColor(red: randomNumber(),green: randomNumber(),blue: randomNumber(),alpha: 1.0)
    }
    
    class func randomNumber() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / CGFloat(255.0)
    }
}
