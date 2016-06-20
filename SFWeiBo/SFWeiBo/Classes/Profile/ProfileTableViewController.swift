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

    let titleArray1 = ["新的好友","微博等级"]
    let titleArray2 = ["我的相册","我的点评","我的赞"]
    let titleArray3 = ["微信支付","微博运动"]
    let titleArray4 = ["粉丝头条","粉丝服务"]
    let titleArray5 = ["草稿箱"]
    let titleArray6 = ["更多"]
    var titleArray = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleArray = [titleArray1,titleArray2,titleArray3,titleArray4,titleArray5,titleArray6]

        //1. 如果没有登录,就设置未登录界面信息
        if !userLogin {
            visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        }
        setupNavigationBar()
        tableView.registerClass(ProfileTopTableViewCell.self, forCellReuseIdentifier: ProfileTopTableViewCellIdentifier)
        tableView.registerClass(ProfileOtherTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCellIdentifier)
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
        } else if section == 1 || section == 3 || section == 4 {
            return 2
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ProfileTopTableViewCellIdentifier, forIndexPath: indexPath) as! ProfileTopTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(ProfileTableViewCellIdentifier, forIndexPath: indexPath) as! ProfileOtherTableViewCell
            cell.labelTitle.text = (titleArray[indexPath.section - 1] as! Array)[indexPath.row] as String
            cell.imageViewIcon.image = UIImage.init(named: "tabbar_home_highlighted")
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            return 50
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
        footerButtonView.addSubview(lineView)

        imageViewHeader.AlignInner(type: AlignType.TopLeft, referView: contentView, size: CGSizeMake(50, 50), offset: CGPointMake(10, 10))
        imageViewIcon.AlignHorizontal(type: AlignType.TopRight, referView: contentView, size: CGSizeMake(20, 25), offset: CGPointMake(-50, 20))
        labelName.AlignHorizontal(type: AlignType.TopRight, referView: imageViewHeader, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 60 - 70, 20),offset: CGPointMake(10, 0))
        labelIntroduce.AlignVertical(type: AlignType.BottomLeft, referView: labelName, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 60 - 70, 20), offset: CGPointMake(0, 10))
        footerButtonView.AlignVertical(type: AlignType.BottomLeft, referView: imageViewHeader, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -10, y: 10))
        footerButtonView.HorizontalTile([footerButton1,footerButton2,footerButton3], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        lineView.AlignInner(type: AlignType.TopLeft, referView: footerButtonView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 0.6), offset: CGPointMake(0, 0))
        
        if let iconUrl = UserAccount.loadAccount()?.avatar_large {
            let url = NSURL(string: iconUrl)!
            imageViewHeader.sd_setImageWithURL(url)
        }
        labelName.text = "少锋"//UserAccount.loadAccount()?.screen_name
        labelIntroduce.text = "简介:暂无介绍"
        imageViewIcon.image = UIImage.init(named: "common_icon_membership_level1")
    }
    
    private lazy var imageViewHeader: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = UIColor.redColor()
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var labelName: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var labelIntroduce: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var imageViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.orangeColor()
        return imageView
    }()
    private lazy var footerButtonView = UIView()
    private lazy var footerButton1: UIButton = {
        let button = UIButton()
        button.setTitle("微博", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        return button;
    }()
    private lazy var footerButton2: UIButton = {
        let button = UIButton()
        button.setTitle("关注", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        return button;
    }()
    private lazy var footerButton3: UIButton = {
        let button = UIButton()
        button.setTitle("粉丝", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        return button;
    }()
    private lazy var lineView: UIView = {
       let line = UIView()
        line.backgroundColor = UIColor.grayColor()
        return line
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfileOtherTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(imageViewIcon)
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelSubTitle)
        
        imageViewIcon.AlignInner(type: AlignType.TopLeft, referView: contentView, size: CGSizeMake(30, 30), offset: CGPointMake(10, 10))
        labelTitle.AlignHorizontal(type: AlignType.TopRight, referView: imageViewIcon, size: CGSizeMake(100, 30), offset: CGPointMake(10, 0))
        labelSubTitle.AlignHorizontal(type: AlignType.TopRight, referView: labelTitle, size: CGSizeMake(100, 30), offset: CGPointMake(10, 0))
    }
    
    private lazy var imageViewIcon = UIImageView()
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 88 / 255.0, green: 88/255.0, blue: 88/255.0, alpha: 1)
        return label
    }()
    private lazy var labelSubTitle = UILabel()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
