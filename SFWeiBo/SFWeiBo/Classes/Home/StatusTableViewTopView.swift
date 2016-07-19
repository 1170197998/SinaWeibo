//
//  StatusTableViewTopView.swift
//  SFWeiBo
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

let clickUserIcon = "clickUserIcon"

class StatusTableViewTopView: UIView {
    
    var status: Status?
        {
        didSet{
            nameLabel.text = status?.user?.name
            timeLabel.text = status?.created_at
            //设置用户头像
            if let url = status?.user?.imageUrl {
                iconView.sd_setImageWithURL(url)
            }
            
            //设置认证图标(根据模型请求下来的数据设置)
            verifiedView.image = status?.user?.verifiedImage
            //设置会员等级图标
            vipView.image = status?.user?.mbrankImage
            //来源设置
            sourceLabel.text = status?.source
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    //创建工具条的三个按钮
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 2.布局子控件（平铺，距离周围的间隙）
        iconView.AlignInner(type: AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.AlignInner(type: AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
        nameLabel.AlignHorizontal(type: AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.AlignHorizontal(type: AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.AlignHorizontal(type: AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.AlignHorizontal(type: AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
    }
    
    @objc private func clickUserInfo() {
        let dict = ["userInfo": status!.user!]
        NSNotificationCenter.defaultCenter().postNotificationName(clickUserIcon, object: nil, userInfo: dict)
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        let ges = UITapGestureRecognizer(target:self,action: #selector(StatusTableViewTopView.clickUserInfo))
        iv.userInteractionEnabled = true
        iv.addGestureRecognizer(ges)
        return iv
    }()
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.creatLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.creatLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.creatLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
