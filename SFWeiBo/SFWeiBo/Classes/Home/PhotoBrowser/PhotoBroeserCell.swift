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
                let size = self.displaySize(image)
                self.pictureView.frame = CGRect(origin: CGPointZero, size: size)
            }
        }
    }
    
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
        addSubview(scrollView)
        addSubview(pictureView)
        
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
