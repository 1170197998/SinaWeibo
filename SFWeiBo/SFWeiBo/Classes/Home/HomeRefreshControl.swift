//
//  HomeRefreshControl.swift
//  SFWeiBo
//
//  Created by mac on 16/4/29.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        
        //初始化UI
        setupUI()
    }
    
    private func setupUI() {
        
        //添加子控件
        addSubview(refreshView)
        
        //布局子控件
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
        
        //监听
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        //移除监听
        removeObserver(self, forKeyPath: "frame")
    }
    
    ///定义变量保存是否需要旋转
    private var rotationArrowFlag = false
    ///记录当前是都正在执行刷新操作
    private var loadingViewAnimFlag = false
    //重写监听方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //过滤掉大于0的数据
        if frame.origin.y >= 0 {
            return
        }
        
        //判断是否出发刷新事件
        if refreshing && !loadingViewAnimFlag{
            //进入刷新状态后显示菊花,不执行箭头相关操作
            loadingViewAnimFlag = true
            refreshView.startLoadingViewAnim()
            return
        }
        
        if frame.origin.y >= -50 && !rotationArrowFlag {
            
            //箭头翻转
            rotationArrowFlag = true
            refreshView.rotationArrowIcon(rotationArrowFlag)
            
        } else if frame.origin.y < -50 && rotationArrowFlag{
            
            //再次翻转
            rotationArrowFlag = false
            refreshView.rotationArrowIcon(rotationArrowFlag)
        }
    }
    
    override func endRefreshing() {
        
        super.endRefreshing()
        
        //关闭加载的菊花动画
        refreshView.stopLoadingViewAnim()
        //复位菊花动画
        loadingViewAnimFlag = false
    }

    //MARK: - 懒加载
    private lazy var refreshView: HomeRefreshView = HomeRefreshView.refreshView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeRefreshView: UIView {
    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var loadingView: UIImageView!
    
    func rotationArrowIcon(flag:Bool) {
        
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        
        //箭头旋转动画(flag记录旋转方向)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    //开始刷新动画
    func startLoadingViewAnim() {
        
        tipView.hidden = true
        //创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        //默认是true,动画执行完就移除
        anim.removedOnCompletion = false
        //将动画添加到图层上
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    //结束刷新动画
    func stopLoadingViewAnim() {
        
        tipView.hidden = false
        loadingView.layer.removeAllAnimations()
    }
    
    class func refreshView() -> HomeRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }
}

