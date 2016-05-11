//
//  StatusTableViewCell.swift
//  SFWeiBo
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SDWebImage

//用于显示图片的collectionView的cell重用标识
let SFPictureCellReuseIdentifier = "SFPictureCellReuseIdentifier"

//保存cell的重用标识
enum StatusTableViewCellIdentifier: String {
    
    //前面的枚举值，后面的是原始值
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    //在枚举中使用status修饰方法，相当于类中的class方法
    //调用枚举的rawValue,相当于拿到枚举的原始值
    //根据模型判断是哪个cell
    static func cellID(status: Status) -> String {
        return status.retweeted_status != nil ? ForwardCell.rawValue : NormalCell.rawValue
    }
}

class StatusTableViewCell: UITableViewCell {
    
    //保存配图的宽高约束
    var pictureWidthCons: NSLayoutConstraint?
    var pictureHeightCons: NSLayoutConstraint?
    
    var pictureTopCons: NSLayoutConstraint?

    
    var status: Status?
        {
        didSet{
            
            //设置顶部视图数据
            topView.status = status
            //设置正文
            contentLabel.text = status?.text
            //设置配图尺寸
            pictureView.status = status?.retweeted_status != nil ? status?.retweeted_status : status
            //根据模型计算配图尺寸,先传递模型，后计算
            let size = pictureView.calculateImageSize()
            //设置配图尺寸
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化UI
        setupUI()
    }
    
    //
    func setupUI() {
        
        // 1.添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footerView)
        
        let width = UIScreen.mainScreen().bounds.width
        // 2.布局子控件
        topView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSizeMake(width, 60))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
    }
    
    //用于获取行高
    func rowHeight(status: Status) -> CGFloat {
        //为了能够调用didSet，计算配图的高度
        self.status = status
        //强制更新UI
        self.layoutIfNeeded()
        //返回底部视图最大的Y值
        return CGRectGetMaxY(footerView.frame)
    }

    // MARK: - 懒加载
    //顶部视图
    private lazy var topView: StatusTableViewTopView = StatusTableViewTopView()
    /// 正文
    lazy var contentLabel: UILabel = {
        let label = UILabel.creatLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        //设置最大宽度
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    ///配图
    lazy var pictureView: StatusPictureView = StatusPictureView()
    /// 底部工具条
    lazy var footerView: StatusTableViewBottomView = StatusTableViewBottomView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}