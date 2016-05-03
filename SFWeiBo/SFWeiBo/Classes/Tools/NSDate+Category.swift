//
//  NSDate+Category.swift
//  SFWeiBo
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func dateWithString(time: String) -> NSDate {
        
        //将服务器下来的时间字符串转换为NSDate
        //创建formatter
        let formatter = NSDateFormatter()
        //设置时间格式
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        //设置时间区域
        formatter.locale = NSLocale(localeIdentifier: "en")
        //转换字符串
        let creatDate = formatter.dateFromString(time)
        return creatDate!
    }
    
    /*
    刚刚(一分钟内)
    x分钟(一小时内)
    x消失前(当天)
    昨天 HH:mm(昨天)
    MM-dd HH:mm(一年内)
    yyyy-MM-dd HH:mm(更早期)
    */
    var descDate: String {
        
        let calendar = NSCalendar.currentCalendar()
        
        //判断是否是今天
        if calendar.isDateInToday(self) {
            //获取当前时间和系统时间的差距(单位是秒)
            //强制转换为Int
            let since = Int(NSDate().timeIntervalSinceDate(self))
            //  是否是刚刚
            if since < 60 {
                return "刚刚"
            }
            //  是否是分钟内
            if since < 60 * 60 {
                return "\(since/60)分钟前"
            }
            //  是否是小时内
            return "\(since / (60 * 60))小时前"
        }
        
        //判断是否是昨天
        var formatterString = "HH:mm"
        if calendar.isDateInYesterday(self) {
            formatterString = "昨天" + formatterString
        } else {
            //判断是否是一年内
            formatterString = "MM-dd" + formatterString
            //判断是否是更早期
            let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            
            if comps.year >= 1 {
                formatterString = "yyyy-" + formatterString
            }
        }
        
        
        //按照指定的格式将日期转换为字符串
        //创建formatter
        let formatter = NSDateFormatter()
        //设置时间格式
        formatter.dateFormat = formatterString
        //设置时间区域
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        //格式化
        return formatter.stringFromDate(self)
    }
}
