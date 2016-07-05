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
    
    /// 单例
    static let tools: NetworkTools = {
        
        let baseUrl = NSURL(string: "https://api.weibo.com/")
        let t = NetworkTools(baseURL: baseUrl)
        
        //设置AFN能够接收的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json","text/json","text/javascript","text/plain") as? Set<String>
        return t
    }()
    
    /**
     类方法获取单例
     */
    class func shareNetworkTools() -> NetworkTools {
        return tools
    }
    
    /**
     发送微博
     
     - parameter text:            文本
     - parameter image:           图片
     - parameter successCallBack: 成功回调
     - parameter errorCallBack:   失败回调
     */
    func sendStatus(text: String, image:UIImage?, successCallBack:(status: Status) -> (),errorCallBack: (error: NSError) -> ()) {
        
        var path = "2/statuses/"
        let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": text]
        
        if image != nil {
            //发送图片微博
            path += "upload.json"
            
            POST(path, parameters: params, constructingBodyWithBlock: { (formData) in
                let data = UIImagePNGRepresentation(image!)!
                
                /*
                 *第一个参数: 需要上传的二进制数据
                 *第二个参数: 服务端对应哪个的字段名称
                 *第三个参数: 文件的名称(一般随便写)
                 *第四个参数: 数据类型, 通用类型application/octet-stream
                 */
                formData.appendPartWithFileData(data, name: "pic", fileName: "a.png", mimeType: "application/octet-stream")
                
                }, progress: { (_) in
                    
                }, success: { (_, JSON) in
                    successCallBack(status: Status(dict: JSON as! [String: AnyObject]))
                }, failure: { (_, error) in
                    errorCallBack(error: error)
            })
        } else {
            //发送文字微博
            path += "update.json"
            POST(path, parameters: params, progress: nil, success: { (_, JSON) in
                successCallBack(status: Status(dict: JSON as! [String: AnyObject]))
                }, failure: { (_, error) in
                    errorCallBack(error: error)
            })
        }
    }
}