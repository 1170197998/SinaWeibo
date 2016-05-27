//
//  StatusForwardTableViewCell.swift
//  SFWeiBo
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class StatusForwardTableViewCell: StatusTableViewCell {

    //重写取数据的方法
    //重写父类属性的didSet，不会影响父类的操作，只需要写自己的需求即可 
    //如果父类写了didSet，那么子类也只能写didSet
    override var status: Status? {
        didSet {
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLabel.text = name + ": " + text
        }
    }
    
    //重写父类的方法时，父类的方法不能是private
    override func setupUI() {
        super.setupUI()
        
        //添加子控件
        //配图在转发背景的上面
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)

        //布局子控件,访问父类中的成员变量时，该成员变量也不能是private
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPointMake(-10, 10))
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: footerView, size: nil)
        forwardLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 10))
        
        // 2.布局子控件
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: forwardLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }
    
    //MARK: - 懒加载
    private lazy var forwardLabel: UILabel = {
        let label = UILabel.creatLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return button
    }()
}
