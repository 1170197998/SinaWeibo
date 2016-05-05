//
//  PhotoBroeserCell.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/5/4.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBroeserCell: UICollectionViewCell {
    
    
    var imageUrl: NSURL? {
        didSet {
            pictureView.sd_setImageWithURL(imageUrl) { (image, _, _, _) in
               
                self.setImageViewPostion()
            }
        }
    }
    
    //调整图片位置
    private func setImageViewPostion() {
        
        //计算图片宽高比
        let size = self.displaySize(pictureView.image!)
        
        //判断图片的高度是否大于屏幕的高度
        if size.height < UIScreen.mainScreen().bounds.height {
            //短图
            pictureView.frame = CGRect(origin: CGPointZero, size: size)
            //处理居中显示(设置上面和下面不显示)
            let y = (UIScreen.mainScreen().bounds.height - size.height) / 2
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
            
        } else {
            //长图
            pictureView.frame = CGRect(origin: CGPointZero, size: size)
            scrollView.contentSize = size
        }
    }
    
    //计算图片宽高比
    private func displaySize(image:UIImage) -> CGSize {
        
        //获取图片的宽高比例
        let scale = image.size.height / image.size.width
        
        //根据宽高比例计算高度
        let width = UIScreen.mainScreen().bounds.size.width
        let height = width * scale
        
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        
        //添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(pictureView)
        
        //布局子控件
        scrollView.frame = UIScreen.mainScreen().bounds
    }
    
    //MARK: - 懒加载子控件
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var pictureView: UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
