//
//  Status.swift
//  SFWeiBo
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    /// 微博创建时间
    var created_at: String? {
        
        didSet {
            //将字符串转换为时间
            let creatDate = NSDate.dateWithString(created_at!)
            //获取格式化之后的时间字符串
            created_at = creatDate.descDate
        }
    }
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String? {
        
        //来源字符串: source	String?	"<a href=\"http://app.weibo.com/t/feed/1tqBja\" rel=\"nofollow\">360安全浏览器</a>"	Some
        //重写didSet方法截取微博来源字符串
        didSet {
            
            if let string = source {
                
                //请求结果为空的时候直接跳过,防止崩溃
                if  string == "" {
                    return
                }
                
                //获取开始截取的位置
                let startLocation = (string as NSString).rangeOfString(">").location + 1
                //获取截取的长度
                //NSStringCompareOptions.BackwardsSearch :从后往前找,找<
                let length = (string as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLocation
                //获取截取的结果
                source = "来自 " + (string as NSString).substringWithRange(NSMakeRange(startLocation, length))
            }
        }
    }
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            //初始化缩略图和大图的URL数组
            storedPicUrls = [NSURL]()
            storedLargePicUrls = [NSURL]()
            
            //遍历取出所有的图片路径字符串
            for dict in pic_urls! {
                if let urlString = dict["thumbnail_pic"] as? String {
                    //把请求下来的图片路径字符串转换为URL,添加到URL数组
                    storedPicUrls!.append(NSURL(string: urlString)!)
                    
                    //处理大图(在缩略图地址中替换参数)
                    let largeUrlString = urlString.stringByReplacingOccurrencesOfString("bmiddle", withString: "large")
                    storedLargePicUrls!.append(NSURL(string: largeUrlString)!)
                    
                }
            }
        }
    }
    ///保存微博缩略图数组URL
    var storedPicUrls: [NSURL]?
    ///保存微博大图数组URL
    var storedLargePicUrls: [NSURL]?
    /// 用户信息
    var user: User?
    ///转发微博
    var retweeted_status: Status?
    /// 定义一个计算属性，用于返回原创或者转发微博缩略图的的URL数组，优先查找转发的配图，用于缓存
    var pictureUrls:[NSURL]? {
        return retweeted_status != nil ? retweeted_status?.pictureUrls : storedPicUrls
    }
    /// 定义一个计算属性，用于返回原创或者转发微博大图的的URL数组，优先查找转发的配图，用于缓存
    var largePictureUrls:[NSURL]? {
        return retweeted_status != nil ? retweeted_status?.largePictureUrls : storedLargePicUrls
    }
    
    // MARK: - 加载微博数据
    //(finished: (models:[Status],error: NSError -> ()) -> ()) :闭包，请求成功后给调用者返回模型或错误
    class func loadStatus(since_id:Int, max_id:Int, finished: (models:[Status]?,error: NSError?) -> ()) {
        
        let path = "2/statuses/home_timeline.json"
        var params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        //下拉刷新
        if since_id > 0 {
            params["since_id"] = "\(since_id)"
        }
        
        //上拉加载
        if max_id > 0 {
            //max_id - 1 移除末尾重复的数据
            params["max_id"] = "\(max_id - 1)"

        }
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: { (_) -> Void in
            
            }, success: { (_, JSON) -> Void in
                //print(JSON)
                // 1.取出statuses key对应的数组 (存储的都是字典)
                // 2.遍历数组, 将字典转换为模型
                let models = dict2Model(JSON!["statuses"] as! [[String: AnyObject]])
                //print(models)
                
                //缓存微博配图(缓存完图片后进行回调)
                cacheStatusImages(models, finished: finished)
                
                // 2.通过闭包将数据传递给调用者
                finished(models: models, error: nil)
                
            }) { (_, error) -> Void in
                print(error)
                finished(models: nil, error: error)
        }
    }
    
    //MARK: - 缓存微博图片
    class func cacheStatusImages(list:[Status],finished: (models:[Status]?,error: NSError?) -> ()) {
        
        if  list.count == 0 {
            //没有值的时候直接返回
            finished(models: list, error: nil)
            return
        }
        
        //创建一个组
        let group = dispatch_group_create()

        for status in list {
            
            //判断当前微博是否有配图,如果没有就直接跳过
            //如果条件为nil,那么就会执行else件后面的语句
            guard  let urls = status.pictureUrls  else {
                continue
            }
            
            //遍历配图数组
            for url in status.pictureUrls! {
                
                //将当前的下载操作添加到组中
                dispatch_group_enter(group)
                //缓存图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    //缓存成功
                    //离开当前组(SDWebImage缓存是异步的)
                    dispatch_group_leave(group)
                })
            }
        }
        //当所有图片都下载完毕后通过闭包通知调用者(每缓存一张图片都会进入/离开组)
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            //所有图片下完后,进行回调
            finished(models: list, error: nil)
        }
    }
    
    /// 将字典数组转换为模型数组
    //[[String: AnyObject]]:是一个数组，数组的每个元素是字典
    class func dict2Model(list: [[String: AnyObject]]) -> [Status] {
        var models = [Status]()
        for dict in list
        {
            //每转换一个模型添加到数组中
            models.append(Status(dict: dict))
        }
        return models
    }
    
    
    // 字典转模型
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    //setValuesForKeysWithDictionary内部会调用下面的方法
    override func setValue(value: AnyObject?, forKey key: String) {
        
        //1. 判断当前是否正在给微博字典中的user字典赋值
        if "user" == key {
            //2. 根据user key对应的字典创建一个模型
            user = User(dict: value as! [String : AnyObject])
            return 
        }
        //2. 判断是否是转发微博，如果是就自己处理
        if "retweeted_status" == key {
            //转发微博字典转模型
            retweeted_status = Status(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    //防止属性不全的时候崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    // 打印当前模型
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
