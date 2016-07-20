//
//  PersonInfoTopTableViewCell.swift
//  SFWeiBo
//
//  Created by ShaoFeng on 16/7/20.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class PersonInfoTopTableViewCell: UITableViewCell {

    
    var user: User? {
        didSet {
            icon.sd_setImageWithURL(user?.imageUrl)
            name.text = user?.name
            
            var string:String?
            switch user!.verified_type {
            case 0:
                string = "avatar_vgirl"
                break
            case 2,3,5:
                string = "avatar_enterprise_vip"
                break
            case 220:
                string = "common_icon_membership"
                break
            default:
                string = ""
            }
            
            verified.image = UIImage.init(named: string!)
        }
    }
    
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var attention: UILabel!
    @IBOutlet var fans: UILabel!
    @IBOutlet var des: UILabel!
    @IBOutlet var verified: UIImageView!
    

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let layer = icon.layer
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
    }
    
}
