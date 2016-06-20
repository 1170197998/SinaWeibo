//
//  StatusNormalTableViewCell.swift
//  SFWeiBo
//
//  Created by mac on 16/4/28.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class StatusNormalTableViewCell: StatusTableViewCell {

    override func setupUI() {
        
        super.setupUI()
        let cons = pictureView.AlignVertical(type: AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
}
