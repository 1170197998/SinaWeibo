//
//  SetupViewController.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/6/13.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
let cellIdentifier = "cellIdentifier"

class SetupViewController: UITableViewController {

    let arrayTitle1 = ["账号管理","账号安全"]
    let arrayTitle2 = ["通知","隐私","通用设置"]
    let arrayTitle3 = ["清除缓存","意见反馈","关于微博"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGrayColor()
        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 || section == 2 {
            return 3
        } else {
            return 4
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if indexPath.section == 0 {
            cell.textLabel?.text = arrayTitle1[indexPath.row]
        }
        if indexPath.section == 1 {
            cell.textLabel?.text = arrayTitle2[indexPath.row]
        }
        if indexPath.section == 2 {
            cell.textLabel?.text = arrayTitle3[indexPath.row]
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
