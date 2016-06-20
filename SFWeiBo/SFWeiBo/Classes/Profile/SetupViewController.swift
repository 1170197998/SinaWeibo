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
        self.title = "设置"
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 229 / 255, green: 228/255, blue: 229/255, alpha: 1)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    //MARK: - 懒加载
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.orangeColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "退出当前账号"
        return label
    }()
}

extension SetupViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 || section == 2 {
            return 3
        } else {
            return 1
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
        if indexPath.section == 3 {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.addSubview(label)
            label.Fill(cell.contentView, insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    //去除header的粘性
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        let sectionHeaderHeight:CGFloat = 20
//        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
//        } else if scrollView.contentOffset.y >= sectionHeaderHeight {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
//        }
//    }
}
