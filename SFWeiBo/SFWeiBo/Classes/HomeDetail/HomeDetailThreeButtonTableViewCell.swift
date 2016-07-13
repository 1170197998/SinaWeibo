//
//  HomeDetailThreeButtonTableViewCell.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/7/7.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class HomeDetailThreeButtonTableViewCell: UITableViewCell {
    
    var mArrayTitle: [String] = []
    var mArrayButton: [UIButton] = []
    var markView: UIView = UIView()
    let markViewIndex :Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mArrayTitle = Array()
        mArrayButton = Array()
        setupUI()
    }
    
    private func setupUI() {
        mArrayTitle = ["转发","赞","评论"]
        
        let width = UIScreen.mainScreen().bounds.size.width
        for i in 0 ..< mArrayTitle.count {
            let button = UIButton.init(frame: CGRectMake(0 + CGFloat(i) * (width - 0) / 3, 0, (width - 0) / 3, 40))
            button.setTitle(mArrayTitle[i], forState: UIControlState.Normal)
            button.titleLabel?.textAlignment = NSTextAlignment.Left
            button.backgroundColor = UIColor.whiteColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.setTitleColor(UIColor.init(colorLiteralRed: 83 / 255.0, green: 83 / 255.0, blue: 83 / 255.0, alpha: 1), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.init(colorLiteralRed: 41 / 255.0, green: 91 / 255.0, blue: 189 / 255.0, alpha: 1), forState: UIControlState.Selected)
            button.tag = i
            button.addTarget(self, action: #selector(clickButtonOnCell(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            contentView.addSubview(button)
            mArrayButton.append(button)
        }
        
        mArrayButton[0].selected = true
        markView = UIView.init(frame: CGRectMake(0 + ((UIScreen.mainScreen().bounds.size.width - 0) / 3) * CGFloat(markViewIndex), 38, (UIScreen.mainScreen().bounds.size.width - 0) / 3, 2))
        markView.backgroundColor = UIColor.darkGrayColor()
        addSubview(markView)
    }
    
    func clickButtonOnCell(button: UIButton) {
        
        for i in 0 ..< 3 {
            if button.tag == i {
                
                UIView.animateWithDuration(0.25, animations: {
                    
                    var rect = self.markView.frame
                    rect.origin.x = 0 + ((UIScreen.mainScreen().bounds.size.width - 0) / 3) * CGFloat(i)
                    self.markView.frame = rect
                })
            }
        }
        for button in mArrayButton {
            if button.selected == true {
                button.selected = false
            }
        }
        button.selected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
