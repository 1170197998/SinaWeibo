//
//  PopoverAnimator.swift
//  SFWeiBo
//
//  Created by mac on 16/3/28.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

//定义常量,保存通知的名称
let PopoverAnimatorWillShow = "PopoverAnimatorWillShow"
let PopoverAnimatorWillDismiss = "PopoverAnimatorWillDismiss"

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    
    
    //定义一个变量,记录当前是展开状态还是消失状态
    var isPresent: Bool = false
    
    //定义一个属性保存菜单的大小
    var presentFrame = CGRectZero
    
    //实现代理方法,告诉系统谁来负责转场动画(弹出)
    //返回值:UIPresentationController  是iOS8推出专门负责转场动画的
    @available(iOS 8.0, *)
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        //设置菜单的大小
        pc.presentFrame = presentFrame
        return pc
    }
    
    //只要实现了以下方法,系统默认的动画效果就都没有了,需要工程师自己实现方法
    //告诉系统谁来负责Modal的展现动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //要展现的时候调用次方法
        isPresent = true
        //发送通知,设置昵称旁边箭头的朝向
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWillShow, object: self)
        return self
    }
    
    //告诉系统谁来负责Modal的消失动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //要消失的时候调用次方法
        isPresent = false
        //发送通知,设置昵称旁边箭头的朝向
        NSNotificationCenter.defaultCenter().postNotificationName(PopoverAnimatorWillDismiss, object: self)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning协议
    //返回动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        //下面展开和关闭的动画市场都是调用这个方法
        return 0.5
    }
    
    //告诉系统,如何动画,无论是展现还是消失,都会调用这个方法
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //拿到展现视图
        /*
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        //通过打印我们可以知道需要修改的就是toVC上面的View
        print(toVC) //Optional(<SFWeiBo.PopoverViewController: 0x7fbc5b0f2ef0>)
        print(fromVC)  //Optional(<SFWeiBo.MainViewController: 0x7fbc5b30d710>)
        */
        
        if isPresent {
            
            //来到这里说明要执行展开操作
            //拿到展现视图
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            //把高度压缩为0
            toView?.transform = CGAffineTransformMakeScale(1.0, 0)
            
            //把视图添加容器上,
            transitionContext.containerView()?.addSubview(toView!)
            
            //设置锚点(由默认的中点移到上面)
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            //执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                //清空transform
                toView?.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                //动画执行完毕后,一定要告诉系统
                transitionContext.completeTransition(true)
            }
        } else {
            
            //来到这里说明要执行关闭操作
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            //执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                //注意: 可能是因为CGFloat不准确,所以写0.0是不准确的
                //压扁(垂直方向收回去)
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000000001)
                }, completion: { (_) -> Void in
                    //告诉系统,动画执行完毕
                    transitionContext.completeTransition(true)
            })
        }
    }
}
