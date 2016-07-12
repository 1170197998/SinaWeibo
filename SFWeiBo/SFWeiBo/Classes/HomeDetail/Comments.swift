//
//  Comments.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/7/12.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class Comments: NSObject {

    /**
     *
     返回值字段	字段类型	字段说明
     created_at	string	评论创建时间
     id	int64	评论的ID
     text	string	评论的内容
     source	string	评论的来源
     user	object	评论作者的用户信息字段 详细
     mid	string	评论的MID
     idstr	string	字符串型的评论ID
     status	object	评论的微博信息字段 详细
     reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段
     */
    
    /// 创建评论时间
    var created_at: String? {
        
        didSet {
            let creatDate = NSDate.dateWithString(created_at!)
            created_at = creatDate.descDate
        }
    }
    
    /// 评论的ID
    var id: Int = 0
    /// 评论内容
    var text: String?
    /// 评论者
    var user: User?
    
    class func loadComments(params: NSDictionary, finished: (models: [Comments]?,error: NSError?) -> ()) {
        
        let path = "2/comments/show.json"
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: nil, success: { (_, JSON) in
            print("55555555555\(JSON)")
            let models = dictModel(JSON!["comments"] as! [[String: AnyObject]])
            finished(models:models,error:nil)
        }) { (_, error) in
            print(error)
        }
    }
    
    class func dictModel(list: [[String: AnyObject]]) -> [Comments] {
        
        var models = [Comments]()
        
        for dict in list {
            models.append(Comments(dict: dict))
        }
        return models
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    //打印当前模型
    var properotoes = ["created_at","id","text","user"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properotoes)
        return "\(dict)"
    }
}
