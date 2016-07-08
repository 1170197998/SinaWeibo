//
//  HomeDetailThreeButtonTableViewCell.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/7/7.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//
/*
 override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
 super.init(style: style, reuseIdentifier: reuseIdentifier)
 setupUI()
 }
 
 private func setupUI() {
 contentView.addSubview(threeButton)
 threeButton.AlignVertical(type: AlignType.TopLeft, referView: contentView, size: CGSizeMake(UIScreen.mainScreen().bounds.width, 44), offset: CGPointMake(0, 0))
 }
 
 private lazy var threeButton: StatusTableViewBottomView = StatusTableViewBottomView()
 */

import UIKit

class HomeDetailThreeButtonTableViewCell: UITableViewCell {

    var mArrayTitle: [String] = []
    var mArrayButton: [String] = []

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mArrayTitle = Array()
        mArrayButton = Array()
        setupUI()
    }
    
    private func setupUI() {
        mArrayTitle = ["评论","赞","转发"]
        
        let width = UIScreen.mainScreen().bounds.size.width
        for i in 0 ..< mArrayTitle.count {
            let button = UIButton.init(frame: CGRectMake(10 + CGFloat(i) * (width - 20) / 3, 0, (width - 20) / 3, 40))
            button.setTitle(mArrayTitle[i], forState: UIControlState.Normal)
            button.titleLabel?.textAlignment = NSTextAlignment.Left
            button.backgroundColor = UIColor.whiteColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.setTitleColor(UIColor.init(colorLiteralRed: 83 / 255.0, green: 83 / 255.0, blue: 83 / 255.0, alpha: 1), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.init(colorLiteralRed: 41 / 255.0, green: 91 / 255.0, blue: 189 / 255.0, alpha: 1), forState: UIControlState.Selected)
            button.tag = i
            button.addTarget(self, action: #selector(clickButtonOnCell(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            contentView.addSubview(button)
            
            
        }
    }
    
    func clickButtonOnCell(button: UIButton) {
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
