//
//  QRCodeCardViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class QRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        //设置标题
        navigationItem.title = "我的名片"
        //添加图片容器
        view.addSubview(iconView)
        //布局图片容器
        iconView.AlignInner(type: AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        //生成二维码
        let qrcodeImage = creatQRCodeImage()
        //将生成的二维码添加到图片容器上
        iconView.image = qrcodeImage
    }
    
    //MARK: - 生成二维码
    private func creatQRCodeImage() -> UIImage{
        
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //还原滤镜的默认属性
        filter?.setDefaults()
        //设置需要生成二维码的数据
        filter?.setValue("少锋".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        //从滤镜中取出生成的图片
        let ciImage = filter?.outputImage
        //这个清晰度不好
//        let bgImage = UIImage(CIImage: ciImage!)
        //这个清晰度好
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 300)
        //创建一个头像
        let icon = UIImage(named: "navigationbar_pop_highlighted")
        //合成图片(把二维码和头像合并)
        let newImage = creatImage(bgImage, iconImage: icon!)
        //返回生成好的二维码
        return newImage
    }
    
    //MARK: - 根据背景图片和头像合成头像二维码
    private func creatImage(bgImage: UIImage, iconImage:UIImage) -> UIImage{
        
        //开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        //绘制背景图片
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        //绘制头像
        let width: CGFloat = 50
        let height: CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        return newImage
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }

    //MARK: - 懒加载
    private lazy var iconView: UIImageView = UIImageView()
}
