//
//  ComposeViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/5/9.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    
    /// 表情键盘布局
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) -> () in
        self.textView.insertEmoticon(emoticon)
    }
    /// 图片选择器
    private lazy var photoSelectorVC: PhotoSelectorViewController = PhotoSelectorViewController()

    ///工具条底部约束
    var toolBarBottonCons: NSLayoutConstraint?
    /// 图片选择器高度约束
    var photoViewHeightCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        //监听键盘弹出和消失
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 将键盘控制器添加为当前控制器的子控制器
        addChildViewController(emoticonVC)
        addChildViewController(photoSelectorVC)
        
        ///导航条
        setupNav()
        ///输入框
        setupInputView()
        ///初始化图片选择器
        setupPhotoView()
        ///工具条
        setupToolbar()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     键盘frame改变会调用次方法
     */
    func keyboardChange(notify: NSNotification) {
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        
        let height = UIScreen.mainScreen().bounds.height
        toolBarBottonCons?.constant = -(height - rect.origin.y)
        
        //更新界面
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animateWithDuration(duration.doubleValue) { () -> Void in
            // 设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            
            self.view.layoutIfNeeded()
        }
        let anim = toolbar.layer.animationForKey("position")
        print("duration = \(anim?.duration)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if photoViewHeightCons == 0 {
            //设置键盘为第一响应
            textView.becomeFirstResponder()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //影藏键盘
        textView.resignFirstResponder()
    }
    
    ///初始化输入框
    private func setupInputView() {
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.allowsEditingTextAttributes = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        textView.Fill(view)
        placeholderLabel.AlignInner(type: AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    ///初始化导航条
    private func setupNav() {
        
        //添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposeViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ComposeViewController.sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        
        //添加中间视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        let label1 = UILabel()
        label1.font = UIFont.systemFontOfSize(15)
        label1.text = "发送微博"
        label1.sizeToFit()
        titleView.addSubview(label1)
        let label2 = UILabel()
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        label2.text = UserAccount.loadAccount()?.screen_name
        label2.sizeToFit()
        titleView.addSubview(label2)
        label1.AlignInner(type: AlignType.TopCenter, referView: titleView, size: nil)
        label2.AlignInner(type: AlignType.BottomCenter, referView: titleView, size: nil)
        navigationItem.titleView = titleView
    }
    
    /**
     设置工具条
     */
    private func setupToolbar() {
        view.addSubview(toolbar)
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings {
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:  nil))
        }
        items.removeLast()
        toolbar.items = items
        
        // 布局toolbar
        let width = UIScreen.mainScreen().bounds.width
        let cons = toolbar.AlignInner(type: AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: 44))
        toolBarBottonCons = toolbar.Constraint(cons, attribute: NSLayoutAttribute.Bottom)
    }
    
    /**
     选择相片
     */
    func selectPicture() {
        textView.resignFirstResponder()
        //调整图片选择器的高度
        photoViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.6
    }

    func setupPhotoView() {
        //添加图片选择器
        view.insertSubview(photoSelectorVC.view, belowSubview: toolbar)
        
        //布局图片选择器
        let size = UIScreen.mainScreen().bounds.size
        let width = size.width
        let height: CGFloat = 0
        let cons = photoSelectorVC.view.AlignInner(type: AlignType.BottomLeft, referView: view, size: CGSizeMake(width, height))
        photoViewHeightCons = photoSelectorVC.view.Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    /**
     切换表情键盘
     */
    func inputEmoticon() {
        // 如果是系统自带的键盘, 那么inputView = nil
        // 如果不是系统自带的键盘, 那么inputView != nil
        // 关闭键盘
        textView.resignFirstResponder()
        // 设置inputView
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        // 从新召唤出键盘
        textView.becomeFirstResponder()
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     发送微博
     */
    func sendStatus() {
        
        let text = textView.emoticonAttributedText()
        let image = photoSelectorVC.pictureImages.first
        
        NetworkTools.shareNetworkTools().sendStatus(text, image: image, successCallBack: { (status) in
            SVProgressHUD.showSuccessWithStatus("发送成功")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            self.close()
        }) { (error) in
            print(error)
            SVProgressHUD.showSuccessWithStatus("发送失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        }
    }
    
    //MARK: - 懒加载
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkGrayColor()
        label.text = "分享新鲜事..."
        return label
    }()
    private lazy var toolbar: UIToolbar = UIToolbar()
}

extension ComposeViewController: UITextViewDelegate {
    
    //监听输入内容
    func textViewDidChange(textView: UITextView) {
        
        //textView.hasText()：是否有内容
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
