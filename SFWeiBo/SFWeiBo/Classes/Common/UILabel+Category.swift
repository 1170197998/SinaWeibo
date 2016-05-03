//
//  UILabel+Category.swift
//  SFWeiBo
//
//  Created by mac on 16/4/21.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

extension UILabel {
    
    ///快速创建一个UILabel
    class func creatLabel(color: UIColor,fontSize: CGFloat) -> UILabel {
        
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}
