//
//  QRCodeViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit
import AVFoundation //扫描二维码用

class QRCodeViewController: UIViewController,UITabBarDelegate {

    //扫描容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    
    //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    
    //冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //底部视图
    @IBOutlet weak var customTabBar: UITabBar!
    
    //保存扫描的结果
    @IBOutlet weak var resultLabel: UILabel!
    
    //监听名片按钮点击
    @IBAction func myCardBtnClick(sender: AnyObject) {
        
        let vc = QRCodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置二维码界面默认选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool){
        
        super.viewWillAppear(animated)
        
        //开始冲击波动画
        starAnimation()
        
        //开始扫描
        starScan()
    }
    
    //扫描二维码
    func starScan() {
        
        //先判断是否能将设备添加到回话中
        if !session.canAddInput(deviceInput) {
            return
        }
        
        //判断是否能够将输出添加到回话中
        if !session .canAddOutput(output) {
            return
        }
        
        //将输入和输出添加到回话中
        session.addInput(deviceInput)
        session.addOutput(output)
        
        //设置输入能够解析的数据类型
        //设置能解析的数据类型,一定要在输出对象添加到会员之后设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        //设置输出对象的代理,只要解析成功,就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        //如果想要实现只扫描一张图片,那么系统自带的二维码扫描功能是不支持的
        //只能设置让二维码只有出现在某一块区域才扫描
//        output.rectOfInterest = CGRectMake(0.0, 0.0, 1, 1)
        
        //添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        //添加绘制图层到预览图层上
        previewLayer.addSublayer(drawLayer)
        
        //告诉session开始扫描
        session.startRunning()
    }
    
    // MARK: - 执行动画
    private func  starAnimation() {
        //让约束从顶部开始
        self.scanLineCons.constant = -self.containerHeightCons.constant
        //强制更新约束
        self.scanLineView.layoutIfNeeded()
        
        //执行冲击波动画
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            
            //利用autoLayout做动画
            //1. 修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
            //设置动画次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            //2. 强制更新约束
            self.scanLineView.layoutIfNeeded()
        })
    }
    
    // MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        //1. 修改容器的高度
        if item.tag == 1 {
            
            //二维码
            self.containerHeightCons.constant = 300
        } else {
            
            //条形码
            self.containerHeightCons.constant = 150
        }
        
        //2. 停止动画,重新设置适合条形码frame的约束
        self.scanLineView.layer.removeAllAnimations()
        
        starAnimation()
    }
    
    // MARK: - 懒加载扫描二维码功能
    //回话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    //拿到输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
       
        //获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            
            //创建输入对象
            let input = try AVCaptureDeviceInput(device: device)
            return input
        } catch {
            
            //打印错误信息
            print(error)
            return nil
        }
    }()
    
    //拿到输出设备
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    //创建用于绘制变现的图层
    private lazy var drawLayer: CALayer = {
        
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
}

//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    //只要解析到数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //清空上一次画好的图层
        clearCorners()
        
        //获取扫描到的数据
        //注意是:stringValue
        print(metadataObjects.last?.stringValue)
        resultLabel.text = metadataObjects.last?.stringValue
        resultLabel.sizeToFit()
        
        //获取扫描到的二维码位置
        //转换坐标
        for object in metadataObjects {
            
            //将坐标转换为界面可识别的坐标
            let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
            
            //绘制图形(根据坐标对象绘制图形)
            drawCorners(codeObject)
        }
    }
    
    //MARK: - 绘制图形
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject) {
        
        //数组为空的时候,直接返回
        if codeObject.corners.isEmpty {
            return
        }
        
        //创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        //创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        
        //绘制第一个点
        //从数组中取出第0个元素,将这个字典中的x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        //绘制其他的三个点
        while index < codeObject.corners.count {
            
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        
        //关闭路径
        path.closePath()
        
        //绘制路径
        layer.path = path.CGPath
        
        //将绘画好的图层添加到drawLayer上
        drawLayer.addSublayer(layer )
    }
    
    //MARK: - 清空上一次画好的矩形变现
    private func clearCorners() {
        
        //判断drawLayer上是否有其他图层
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0 {
            return
        }
        
        //移除子图层
        for subLayer in drawLayer.sublayers! {
            
            subLayer.removeFromSuperlayer()
        }
    }
}