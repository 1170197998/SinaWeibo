

//
//  PersonInfoViewController.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/7/19.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class PersonInfoViewController: UIViewController {

    var user: User?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = user?.name
        view.addSubview(tableView)
    }
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.frame = UIScreen.mainScreen().bounds
        return tableView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
