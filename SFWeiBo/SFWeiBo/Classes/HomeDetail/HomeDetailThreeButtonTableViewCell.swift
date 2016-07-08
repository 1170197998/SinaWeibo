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

    var mArray: [String] = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mArray = Array()
        setupUI()
    }
    
    private func setupUI() {
        mArray = ["评论","赞","转发"]
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
