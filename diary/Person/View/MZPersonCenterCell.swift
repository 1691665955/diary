//
//  MZPersonCenterCell.swift
//  diary
//
//  Created by 曾龙 on 2019/3/1.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit

enum MZPersonCenterCellType:Int {
    case password = 0
    case history = 1
    case star = 2
}

class MZPersonCenterCell: UITableViewCell {

    @IBOutlet weak var tipLB: UILabel!
    var type: MZPersonCenterCellType! {
        didSet {
            switch type! {
            case .password:
                self.tipLB.text = "修改密码";
            case .history:
                self.tipLB.text = "浏览历史";
            case .star:
                self.tipLB.text = "我的点赞";
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
