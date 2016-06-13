//
//  AddFriendViewController.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/6/13.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
let addFriendCellIdentifier = "addFriendCellIdentifier"

class AddFriendViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        tableView.tableFooterView = UIView()
        tableView.registerClass(AddFriendTableViewCell.self, forCellReuseIdentifier: addFriendCellIdentifier)
    }
    
    private func setupNavigationBar() {
        self.title = "添加好友"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_gengduo"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(AddFriendViewController.rightBarButtonClick))
    }
    
    func rightBarButtonClick() {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(addFriendCellIdentifier, forIndexPath: indexPath) as! AddFriendTableViewCell
        return cell
    }

    
}
