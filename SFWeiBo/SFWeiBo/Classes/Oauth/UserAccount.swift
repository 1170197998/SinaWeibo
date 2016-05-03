//
//  UserAccount.swift
//  SFWeiBo
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SVProgressHUD
class UserAccount: NSObject,NSCoding {

    /*
    access_token	string	用户授权的唯一票据，用于调用微博的开放接口，
    expires_in	string	access_token的生命周期，单位是秒数。
    remind_in	string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
    uid	string	授权用户的UID，   
    */
    var access_token: String?
    var expires_in: NSNumber? {
        didSet {
            //赋值的时候调用次方法(根据过期的秒数生成真正的过期时间)
            expires_Date = NSDate(timeIntervalSince1970: (expires_in?.doubleValue)!)
        }
    }
    //保存用户过期时间
    var expires_Date: NSDate?
    var uid: String?
    
    //用户头像(大图)
    var avatar_large: String?
    //用户昵称
    var screen_name: String?
    
    override init() {
        
    }
    
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        //忽略没有的key
        print(key)
    }
    
    //重写description
    override var description: String {
        
        //定义属性数组
        let property = ["access_token","expires_in","uid","expires_Date","avatar_large","screen_name"]
        //根据属性数组,将属性转换为字典
        let dict = self.dictionaryWithValuesForKeys(property)
        //将字典转换为字符串
        return "\(dict)"
    }
    
    func loadUserInfo(finish: (account: UserAccount?, error:NSError?) -> ()) {
        
        //断言
        assert(access_token != nil, "没有授权")
        
        let path = "2/users/show.json"
        let params = ["access_token":access_token!, "uid":uid!]
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: { (_) -> Void in
            
            }, success: { (_, JSON) -> Void in
                
                print(JSON)
                //判断字典是否有值
                if let dict = JSON as? [String: AnyObject] {
                    
                    self.screen_name = dict["screen_name"] as? String
                    self.avatar_large = dict["avatar_large"] as? String
                    //保存用户信息
                    //self.saveAccount()
                    finish(account: self, error: nil)
                    return
                }
                finish(account: nil, error: nil)
                
            }) { (_, error) -> Void in
                print(error)
                finish(account: nil, error: error)
        }
    }
    
    
    //返回用户是否登录
    class func userLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    }
    
    //MARK: - 保存和读取  Keyed
    static let filePath = "account.plist".cacheDir()
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath) //对象发放访问需要加类名
    }
    
    //加载授权模型
    static var account: UserAccount?
    class func loadAccount() -> UserAccount? {
        
        //判断是否已经记载过(已经加载过则不加载)
        if account != nil {
            return account
        }
        //加载授权模型
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount  //类方法直接访问
        
        //判断授权信息是否过期
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            //已经过期
            return nil
        }
        return account
    }
    
    //MARK: - NSCoding
    //写入到文件
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    //从文件中读取
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
}
