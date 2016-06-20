//
//  VisitorView.swift
//  SFWeiBo
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

//制定协议(遵守NSObjectProtocol协议)
protocol VisitorViewDelegate:NSObjectProtocol {
    
    //登录按钮的点击
    func loginButotnWillClick()
    //注册按钮的点击
    func registerButtonWillClick()
}

class VisitorView: UIView {

    
    //定义属性保存代理对象(加weak)
    weak var delegate:VisitorViewDelegate?
    
    //设置未登录界面
    func setupVisitorInfo(isHome:Bool, imageName:String,message:String) {
        
        //如果不是首页,就隐藏转盘
        iconView.hidden = !isHome
        //修改中间图标
        homeIcon.image = UIImage(named: imageName)
        //修改文本
        messageLabel.text = message
        
        //判断是否需要执行动画
        if isHome {
            starAnimation()
        }
    }
    
    func loginButtonClick() {
        //print(__FUNCTION__)
        delegate?.loginButotnWillClick()
    }
    
    func registerButtonClick() {
        //print(__FUNCTION__)
        delegate?.registerButtonWillClick()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加子空间
        addSubview(iconView)
        addSubview(maskBackGroundView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        //布局子空间
        //设置背景
        iconView.AlignInner(type:AlignType.Center, referView: self, size: nil)
        //设置小房子
        homeIcon.AlignInner(type: AlignType.Center, referView: self, size: nil)
        //设置文本
        messageLabel.AlignVertical(type: AlignType.BottomCenter, referView: iconView, size: nil)
        
        //"哪个控件"的"什么属性" "等于" "另一个控件" "乘以多少" "加上多少"
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        
        //设置按钮
        registerButton.AlignVertical(type: AlignType.BottomLeft, referView: messageLabel, size: CGSizeMake(100, 30), offset: CGPointMake(0, 20))
        loginButton.AlignVertical(type: AlignType.BottomRight, referView: messageLabel, size: CGSizeMake(100, 30), offset: CGPointMake(0, 20))
        
        //设置蒙版
        maskBackGroundView.Fill(self)
    }

    //swift推荐自定义一个控件,要么纯代码,要吗用xib/storyBoard
    //自定义View系统提示必须要写的方法
    required init?(coder aDecoder: NSCoder) {
        //如果通过xib/storyBoard创建该类,那么就会崩溃
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 内部控制方法
    private func starAnimation() {
        
        //创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        //默认是true,动画执行完就移除
        anim.removedOnCompletion = false
        //将动画添加到图层上
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    // MARK: - 懒加载控件(房子图标,转盘,提示文字,登录按钮,注册按钮,蒙版图片)
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return imageView
    }()
    private lazy var homeIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return imageView
    }()
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        return label
    }()
    private lazy var loginButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.setTitle("登录", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(VisitorView.loginButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    private lazy var registerButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.orangeColor (), forState: UIControlState.Normal)
        button.setTitle("注册", forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(VisitorView.registerButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    private lazy var maskBackGroundView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return imageView
    }()
}
