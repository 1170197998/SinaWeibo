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

    let titleArray = ["当面添加好友","扫一扫","通讯录好友"]
    let subTitleArray = ["添加身边的朋友","扫描二维码名片","添加或邀请通讯录中的好友"]
    let imageIconArray = ["tab_my_press","tab_bg_da_nor","my_icon_file"]
    
    
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
}

extension AddFriendViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(addFriendCellIdentifier, forIndexPath: indexPath) as! AddFriendTableViewCell
        cell.imageViewIcon.image = UIImage(named: imageIconArray[indexPath.row])
        cell.title.text = titleArray[indexPath.row]
        cell.subTitle.text = subTitleArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
}

class AddFriendTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(imageViewIcon)
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        
        imageViewIcon.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSizeMake(38, 40), offset: CGPointMake(10, 10))
        title.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: imageViewIcon, size: CGSizeMake(150, 20), offset: CGPointMake(10, 0))
        subTitle.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: title, size: CGSizeMake(150, 20), offset: CGPointMake(0, 5))
    }
    
    lazy var imageViewIcon : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 88/255.0, green: 88/255.0, blue: 88/255.0, alpha: 1)
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.init(red: 88/255.0, green: 88/255.0, blue: 88/255.0, alpha: 1)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

