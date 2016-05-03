//
//  PhotoBrowserViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/5/2.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {

    var currentIndex: Int?
    var pictureUrls: [NSURL]?
    
    
    init(index: Int,urls:[NSURL]) {
        
        currentIndex = index
        pictureUrls = urls
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupUI()
    }
    
    private func setupUI() {
        
        //添加子控制器
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        //布局控件
        closeButton.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSizeMake(100, 35),offset: CGPointMake(10, -10))
        saveButton.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: view, size: CGSizeMake(100, 35),offset: CGPointMake(-10, -10))
        collectionView.frame = UIScreen.mainScreen().bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 懒加载
    private lazy var closeButton:UIButton = {
       
        let button = UIButton()
        button.setTitle("关闭", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        button.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var saveButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("保存", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        button.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRectZero,collectionViewLayout: UICollectionViewFlowLayout())
    
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        
    }
}
