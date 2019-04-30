//
//  MZMyInfoCell.swift
//  diary
//
//  Created by 曾龙 on 2019/3/1.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit

enum MZMyInfoCellType:Int {
    case avatar = 0
    case nickname = 1
    case sex = 2
}

class MZMyInfoCell: UITableViewCell {

    @IBOutlet weak var tipLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    var type: MZMyInfoCellType! {
        didSet {
            switch type! {
            case .avatar:
                self.tipLB.text = "我的头像";
                self.contentLB.isHidden = true;
                self.avatarView.isHidden = false;
            case .nickname:
                self.tipLB.text = "昵称";
                self.contentLB.isHidden = false;
                self.avatarView.isHidden = true;
            case .sex:
                self.tipLB.text = "性别";
                self.contentLB.isHidden = false;
                self.avatarView.isHidden = true;
            }
        }
    }
    
    var model: MZUser! {
        didSet {
            switch self.type! {
            case .avatar:
                self.avatarView.sd_setImage(with: URL.init(string: model.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed) { (image, error, cacheType, url) in
                    
                }
            case .nickname:
                self.contentLB.text = model.username;
                self.contentLB.textColor = RGB(r: 51, g: 51, b: 51);
            case .sex:
                if (model.sex == "0") {
                    self.contentLB.text = "请选择";
                    self.contentLB.textColor = RGB(r: 136, g: 136, b: 136);
                } else if (model.sex == "1") {
                    self.contentLB.text = "男";
                    self.contentLB.textColor = RGB(r: 51, g: 51, b: 51);
                } else {
                    self.contentLB.text = "女";
                    self.contentLB.textColor = RGB(r: 51, g: 51, b: 51);
                }
            }
        }
    }
    
    var avatar: UIImage! {
        didSet {
            self.avatarView.image = avatar;
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
