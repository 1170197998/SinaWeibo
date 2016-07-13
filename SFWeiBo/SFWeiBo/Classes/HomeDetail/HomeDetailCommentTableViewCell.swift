//
//  HomeDetailCommentTableViewCell.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/7/12.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class HomeDetailCommentTableViewCell: UITableViewCell {

    var comment: Comments? {
        didSet {
            if ((comment?.created_at) != nil) {
                dateLabel.text = comment?.created_at
            } else {
                dateLabel.text = ""
            }
            
            if ((comment?.text) != nil) {
                contentLabel.text = comment?.text
            } else {
                contentLabel.text = nil
            }

            nameLabel.text = comment?.user?.name
            
            //设置用户头像
            if let url = comment?.user?.imageUrl {
                headerIcon.sd_setImageWithURL(url)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    
    private func setupUI() {
        contentView.addSubview(headerIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        
        headerIcon.AlignInner(type: AlignType.TopLeft, referView: contentView, size: CGSizeMake(35, 35), offset: CGPointMake(5, 5))
        nameLabel.AlignHorizontal(type: AlignType.TopRight, referView: headerIcon, size: CGSizeMake(200, 20), offset: CGPointMake(10, 0))
        dateLabel.AlignVertical(type: AlignType.BottomLeft, referView: nameLabel, size: CGSizeMake(150, 15), offset: CGPointMake(0, 5))
        contentLabel.AlignVertical(type: AlignType.BottomLeft, referView: dateLabel, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 50, 20), offset: CGPointMake(0, 5))
    }
    
    private lazy var headerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.redColor()
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var contentLabel: UILabel = {
       let label = UILabel()
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
