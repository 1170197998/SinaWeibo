//
//  ProfileTableViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

let ProfileTableViewCellIdentifier = "ProfileTableViewCellIdentifier"

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1. 如果没有登录,就设置未登录界面信息
        if !userLogin {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
        setupNavigationBar()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ProfileTableViewCellIdentifier)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友",style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ProfileTableViewController.leftBarButtonItemClick))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "设置",style: UIBarButtonItemStyle.Plain, target:self, action:#selector(ProfileTableViewController.rightBarButtonItemClick))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
    }
    
    func leftBarButtonItemClick() {
        let vc = AddFriendViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightBarButtonItemClick() {
        let vc = SetupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 5 || section == 6 {
            return 1
        } else if section == 1 || section == 4 || section == 5{
            return 2
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ProfileTableViewCellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
}

class ProfileTopTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(imageViewHeader)
        contentView.addSubview(labelName)
        contentView.addSubview(labelIntroduce)
        contentView.addSubview(imageViewIcon)
        
        imageViewHeader.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSizeMake(40, 40), offset: CGPointMake(10, 10))
        labelName.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: imageViewHeader, size: CGSizeMake(100, 20), offset: CGPointMake(10, 0))
    }
    
    private lazy var imageViewHeader: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = UIColor.redColor()
        return imageView
    }()
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.blueColor()
        return label
    }()
    private lazy var labelIntroduce: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grayColor()
        return label
    }()
    private lazy var imageViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.orangeColor()
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
