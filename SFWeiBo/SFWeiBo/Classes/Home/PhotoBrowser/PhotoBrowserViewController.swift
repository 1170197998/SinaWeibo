//
//  PhotoBrowserViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/5/2.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SVProgressHUD

//cell重用标识
private let  photoBrowserCellReuseIdentifier = "pictureCell"

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
        
        //设置数据源
        collectionView.dataSource = self
        collectionView.registerClass(PhotoBroeserCell.self, forCellWithReuseIdentifier: photoBrowserCellReuseIdentifier)
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
        button.addTarget(self, action: #selector(PhotoBrowserViewController.close), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var saveButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("保存", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        button.addTarget(self, action: #selector(PhotoBrowserViewController.save), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRectZero,collectionViewLayout: photoBrowserLayout())
    
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        
        //拿到当前显示的cell
        let index = collectionView.indexPathsForVisibleItems().last
        let cell = collectionView.cellForItemAtIndexPath(index!) as! PhotoBroeserCell
        
        //保存图片
        let image = cell.pictureView.image
        
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(PhotoBrowserViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            SVProgressHUD.showErrorWithStatus("保存失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        } else {
            SVProgressHUD.showSuccessWithStatus("保存成功")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        }
    }
}

// MARK: - 自定义cell
extension PhotoBrowserViewController: UICollectionViewDataSource,PhotoBrowserCellDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureUrls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCellReuseIdentifier, forIndexPath: indexPath) as! PhotoBroeserCell
        cell.imageUrl = pictureUrls![indexPath.item]
        cell.photoBrowserCellDelegate =  self

        return cell
    }
    
    func photoBrowserCellDidClose(cell: PhotoBroeserCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

/// cell布局
class photoBrowserLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
}
