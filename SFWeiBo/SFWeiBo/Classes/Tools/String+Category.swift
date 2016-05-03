//
//  String+Category.swift
//  SFWeiBo
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//  String的分类

import UIKit

extension String {
    
    ///将当前字符串拼接到cache目录
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    ///将当前字符串拼接到doc目录
    func doceDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    ///将当前字符串拼接到tmp目录
    func tmpDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
}