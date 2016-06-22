//
//  PopoverViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/27.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let arrayTitle = ["首页","好友圈","特别关注","媒体","同事","同学","名人明星","悄悄关注"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PopoverViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitle.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var cell = tableView.dequeueReusableCellWithIdentifier("id")
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "id")
        }
        cell?.textLabel?.text = arrayTitle[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("界面切换")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

