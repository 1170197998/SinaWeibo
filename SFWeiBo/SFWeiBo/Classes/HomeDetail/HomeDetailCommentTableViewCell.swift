//
//  HomeDetailCommentTableViewCell.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/7/12.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class HomeDetailCommentTableViewCell: UITableViewCell {
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.darkTextColor()
        return label
    }()
    
    var comment: Comments? {
        didSet {
            
            //名字赋值
            nameLabel.text = comment?.user?.name
            //用户头像赋值
            if let url = comment?.user?.imageUrl {
                headerIcon.sd_setImageWithURL(url)
            }
            //时间赋值
            if let string = comment?.created_at {
                dateLabel.text = string
            }
            //评论内容赋值
            if let string = comment?.text {
                
                let attributesString = NSMutableAttributedString.init(string: string)
                
                let paraghStyle = NSMutableParagraphStyle()
                paraghStyle.lineSpacing = 3
                attributesString.addAttributes([NSParagraphStyleAttributeName : paraghStyle], range: NSMakeRange(0, string.characters.count))
                contentLabel.attributedText = attributesString
                contentLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                contentLabel.contentMode = UIViewContentMode.Top
                
                let attributes = [NSFontAttributeName:contentLabel.font,NSParagraphStyleAttributeName:paraghStyle]
                let text: NSString = NSString(CString: string.cStringUsingEncoding(NSUTF8StringEncoding)!, encoding: NSUTF8StringEncoding)!

                let size = text.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 60, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
                
                contentLabel.text = attributesString.string
                contentLabel.frame = CGRectMake(50, 50, size.width, size.height)
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
//        contentLabel.AlignVertical(type: AlignType.BottomLeft, referView: dateLabel, size: CGSizeMake(UIScreen.mainScreen().bounds.width - 50, 20), offset: CGPointMake(0, 5))
    }
    
    private lazy var headerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.darkTextColor()
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkTextColor()
        return label
    }()    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
