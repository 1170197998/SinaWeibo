//
//  ProfileTableViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

let ProfileTopTableViewCellIdentifier = "ProfileTopTableViewCellIdentifier"
let ProfileTableViewCellIdentifier = "ProfileTableViewCellIdentifier"

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1. 如果没有登录,就设置未登录界面信息
        if !userLogin {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
        setupNavigationBar()
        tableView.registerClass(ProfileTopTableViewCell.self, forCellReuseIdentifier: ProfileTopTableViewCellIdentifier)
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
        
        if indexPath.section == 0 {
            return tableView.dequeueReusableCellWithIdentifier(ProfileTopTableViewCellIdentifier, forIndexPath: indexPath) as! ProfileTopTableViewCell
        } else {
            return tableView.dequeueReusableCellWithIdentifier(ProfileTableViewCellIdentifier, forIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 44
        }
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
        contentView.addSubview(footerButtonView)
        footerButtonView.addSubview(footerButton1)
        footerButtonView.addSubview(footerButton2)
        footerButtonView.addSubview(footerButton3)

        imageViewHeader.AlignInner(type: AlignType.TopLeft, referView: contentView, size: CGSizeMake(50, 50), offset: CGPointMake(10, 10))
        imageViewIcon.AlignHorizontal(type: AlignType.TopRight, referView: contentView, size: CGSizeMake(35, 25), offset: CGPointMake(-50, 20))
        labelName.AlignHorizontal(type: AlignType.TopRight, referView: imageViewHeader, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 60 - 70, 20),offset: CGPointMake(10, 0))
        labelIntroduce.AlignVertical(type: AlignType.BottomLeft, referView: labelName, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 60 - 70, 20), offset: CGPointMake(0, 10))
        footerButtonView.AlignVertical(type: AlignType.BottomLeft, referView: imageViewHeader, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -10, y: 10))
        footerButtonView.HorizontalTile([footerButton1,footerButton2,footerButton3], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
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
    private lazy var footerButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    private lazy var footerButton1: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orangeColor()
        button.setTitle("微博", forState: UIControlState.Normal)
        return button;
    }()
    private lazy var footerButton2: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("关注", forState: UIControlState.Normal)
        return button;
    }()
    private lazy var footerButton3: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orangeColor()
        button.setTitle("粉丝", forState: UIControlState.Normal)
        return button;
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
