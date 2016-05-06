//
//  PhotoBroeserCell.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/5/4.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import SDWebImage

//点击关闭图片
protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    func photoBrowserCellDidClose(cell: PhotoBroeserCell)
}

class PhotoBroeserCell: UICollectionViewCell {
    
    weak var photoBrowserCellDelegate: PhotoBrowserCellDelegate?
    
    var imageUrl: NSURL? {
        didSet {
            
            //重置属性
            reset()
            
            //显示菊花
            activity.startAnimating()

            pictureView.sd_setImageWithURL(imageUrl) { (image, _, _, _) in
               
                //隐藏菊花
                self.activity.stopAnimating()

                self.setImageViewPostion()
            }
        }
    }
    
    ///重置scrollView和pictureView的属性(清空尺寸和位置)
    private func reset() {
        
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        
        pictureView.transform = CGAffineTransformIdentity
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
        activity.center = contentView.center
        
        //处理缩放
        scrollView.delegate = self
        //缩放比例
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        //监听图片点击关闭
        let tap = UITapGestureRecognizer(target: self, action: #selector(NSStream.close))
        pictureView.addGestureRecognizer(tap)
        pictureView.userInteractionEnabled = true
    }
    
    //点击关闭图片(此方法不能是private)
    func close() {
        photoBrowserCellDelegate?.photoBrowserCellDidClose(self)
    }
    
    //MARK: - 懒加载子控件
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var pictureView: UIImageView = UIImageView()
    //菊花
    private lazy var activity: UIActivityIndicatorView =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBroeserCell: UIScrollViewDelegate {
    
    //缩放的控件
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return pictureView
    }
    
    //重新调整缩放后的配图的位置(view:被缩放的视图)
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        //缩放的时候frame改变,bounds不变,缩放内部修改的是transform
        
        var offsetX = (UIScreen.mainScreen().bounds.size.width - (view?.frame.width)!) / 2
        var offsetY = (UIScreen.mainScreen().bounds.size.height - (view?.frame.height)!) / 2
        
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}
