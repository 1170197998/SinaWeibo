//
//  StatusPictureView.swift
//  SFWeiBo
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SDWebImage
class StatusPictureView: UICollectionView {
    
    var status: Status? {
        
        didSet {
            reloadData()
        }
    }
    
    ///配图布局
    private var pictureLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    init() {
        super.init(frame:CGRectZero,collectionViewLayout: pictureLayout)
        
        //注册显示图片collectionView的cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: SFPictureCellReuseIdentifier)
        
        dataSource = self
        delegate = self
        
        //设置cell之间的间隙
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        //设置配图的背景颜色
        backgroundColor = UIColor.darkGrayColor()
    }
    
    ///计算配图的尺寸(所有图片所占位置的大小)
    //返回整个配图的大小 和 cell的大小
    func calculateImageSize() -> CGSize {
        //取出配图的个数
        let count = status?.storedPicUrls?.count
        //如果没有配图
        if count == 0 || count == nil {
            return CGSizeZero
        }
        //一张配图时,返回实际大小
        if count == 1 {
            // 3.1取出缓存的图片
            let key = status?.storedPicUrls!.first?.absoluteString
            //有可能缓存中图片为空
            if let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!) {
                
                pictureLayout.itemSize = image.size
                // 3.2返回缓存图片的尺寸
                return image.size
            }
        }
        //4张配图时,田字格布局
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        if count == 4 {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        /*
        2/3
        5/6
        7/8/9
        */
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        //               (8 - 1) / 3 + 1
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    //PictureViewCell这个类只有本类：StatusPictureView使用时，可以把这个类放入本类中
    private class PictureViewCell: UICollectionViewCell {
        
        // 定义属性接收外界传入的数据
        var imageURL: NSURL?
            {
            didSet{
                iconImageView.sd_setImageWithURL(imageURL!)
                //判断是否是gif(先取后缀,然后转小写)
                if (imageURL!.absoluteString as NSString).pathExtension.lowercaseString == "gif" {
                    gifImageView.hidden = false
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            // 初始化UI
            setupUI()
        }
        
        private func setupUI() {
            // 1.添加子控件
            contentView.addSubview(iconImageView)
            iconImageView.addSubview(gifImageView)

            // 2.布局子控件
            iconImageView.xmg_Fill(contentView)
            gifImageView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconImageView, size: nil)
        }
        
        // MARK: - 懒加载
        private lazy var iconImageView:UIImageView = UIImageView()
        private lazy var gifImageView:UIImageView = {
            
            let imageView = UIImageView(image: UIImage(named: "avatar_vgirl"))
            imageView.hidden = true
            return imageView
        }()

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///点击图片时候的通知名称
let SFStatusPictureViewSelected = "SFStatusPictureViewSelected"
///当前选中图片索引对应的key
let SFStatusPictureViewIndexKey = "SFStatusPictureViewIndexKey"
///当前展示图片对应的图片数组
let SFStatusPictureViewUrlsKey = "SFStatusPictureViewUrlsKey"

extension StatusPictureView: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //如果是nil就你返回0
        return status?.storedPicUrls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //取出cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SFPictureCellReuseIdentifier, forIndexPath: indexPath) as! PictureViewCell
        //设置数据
        cell.imageURL = status?.storedPicUrls![indexPath.item]
        //返回cell
        return cell
    }
    
    //delegate检测点击索引
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //点击图片的时候发送通知,弹出图片浏览器
        //通知中传递两个参数,当前点击的图片索引和对应的图片数组
        NSNotificationCenter.defaultCenter().postNotificationName(SFStatusPictureViewSelected, object: self, userInfo: [SFStatusPictureViewIndexKey: indexPath,SFStatusPictureViewUrlsKey: (status?.storedLargePicUrls!)!])
    }
}
