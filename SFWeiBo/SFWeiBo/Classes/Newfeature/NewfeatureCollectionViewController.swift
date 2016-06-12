//
//  NewfeatureCollectionViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/4/9.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//
//在Swift中private修饰的变量或者方法,只能在在本文件中可以访问,若本文件中有多个类,那么别的类也可以访问这个变量或者方法

import UIKit

//重用标识
private let reuseIdentifier = "reuseIdentifier"
class NewfeatureCollectionViewController: UICollectionViewController {
    
    //页面个数
    private let pageCount = 4
    //布局对象(自定义布局)
    private var layout: UICollectionViewFlowLayout = NewfeatureLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册一个cell
        collectionView?.registerClass(NewfearureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - UICollectionDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfearureCell
        //设置cell数据
        //        cell.backgroundColor = UIColor.redColor()
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    //MARK: - 完全显示一个cell后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //拿到当前显示cell对应的索引
        let path = collectionView.indexPathsForVisibleItems().last!
        
        if path.item == (pageCount - 1) {
            
            //拿到当前索引对应的cell
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfearureCell
            
            //让cell执行按钮动画
            cell.starButtonAnimation()
        }
    }
}

//MARK: - Swift中一个文件可以定义多个类
//MARK: 自定义collectionViewCell
//如果当前类需要监听按钮的点击事件,那么当前类不能是私有的(private)
class NewfearureCell: UICollectionViewCell {
    
    //保存图片索引
    private var imageIndex:Int? {
        didSet {
            //根据页码创建图片名字
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
            if imageIndex == 3 {
                starButton.hidden = false
                starButtonAnimation()
            } else {
                starButton.hidden = true
                
            }
        }
    }
    
    //MARK: - 按钮动画
    func starButtonAnimation() {
        //执行动画
        //初始大小为0,并且不可点击
        starButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        starButton.userInteractionEnabled = false
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            //清空变形
            self.starButton.transform = CGAffineTransformIdentity
            
            },completion: { (_) -> Void in
                self.starButton.userInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化UI
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        //添加子控件到contentView
        contentView.addSubview(iconView)
        contentView.addSubview(starButton)
        //布局子控件位置(填充屏幕)
        iconView.xmg_Fill(contentView)
        starButton.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    //MARK:  懒加载
    private lazy var iconView = UIImageView()
    private lazy var starButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: #selector(NewfearureCell.starButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    func starButtonClick() {
        //进入微博
        NSNotificationCenter.defaultCenter().postNotificationName(SFSwitchRootViewController, object: true)
    }
}

//MARK: - 继承UICollectionViewFlowLayout,自定义布局
private class NewfeatureLayout: UICollectionViewFlowLayout {
    
    //重写系统准备布局的方法
    //这个方法在返回多少行的方法之后,在返回cell的方法之前调用
    override func prepareLayout() {
        
        //设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        //设置其他属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}
