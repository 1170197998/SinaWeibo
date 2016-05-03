//
//  NetworkTools.swift
//  SFWeiBo
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//  单例类

import UIKit
import AFNetworking


class NetworkTools: AFHTTPSessionManager {
    
    //单例
    static let tools: NetworkTools = {
        
        let baseUrl = NSURL(string: "https://api.weibo.com/")
        let t = NetworkTools(baseURL: baseUrl)
        
        //设置AFN能够接收的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json","text/json","text/javascript","text/plain") as? Set<String>
        return t
    }()
    
    //类方法获取单例
    class func shareNetworkTools() -> NetworkTools {
        return tools
    }
}