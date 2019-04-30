//
//  MZMainPageTextCell.swift
//  diary
//
//  Created by 曾龙 on 2019/2/25.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZMainPageTextCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nicknameLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var readLB: UILabel!
    @IBOutlet weak var commandLB: UILabel!
    @IBOutlet weak var likeLB: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeView: UIView!
    
    var starBlock: (()->Void)!
    var showUserDetail:((_ userID:String?) -> Void)!
    
    var model: MZDiaryModel! {
        didSet {
            self.iconView!.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
                
            })
            self.nicknameLB.text = model.username;
            self.timeLB.text = model.time!.getFormatterTimeString();
            self.contentLB.text = model.content;
            self.readLB.text = model.read;
            self.commandLB.text = model.commentCount;
            self.likeLB.text = model.star;
            if model.hasStar == "1" {
                self.likeImageView.image = UIImage.init(named: "like_selected");
            } else {
                self.likeImageView.image = UIImage.init(named: "like_normal");
            }
            
            let maxSize = CGSize.init(width: SCREEN_WIDTH-28, height: CGFloat.greatestFiniteMagnitude);
            let size = self.contentLB.sizeThatFits(maxSize);
            if size.height > 100 {
                self.contentHeight.constant = 120;
            } else if (size.height > 20){
                self.contentHeight.constant = size.height;
            } else {
                self.contentHeight.constant = 20;
            }
            
            self.Height = 108 + self.contentHeight.constant;
        }
    }
    var Height: CGFloat!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(like));
        self.likeView.addGestureRecognizer(tap);
        
        let iconTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        self.iconView.addGestureRecognizer(iconTap);
        let nameTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        self.nicknameLB.addGestureRecognizer(nameTap);
    }
    
    @objc func tapClicked() -> Void {
        if self.showUserDetail != nil {
            self.showUserDetail(self.model.userID);
        }
    }
    
    @objc func like() -> Void {
        if self.model.hasStar == "1" {
            MZAPI.cancelStar(diaryID: self.model.diaryID) { (data, rmsg) in
                if rmsg == "ok" {
                    self.likeImageView.image = UIImage.init(named: "like_normal");
                    self.model.hasStar = "0";
                    self.model.star = String(Int(self.model.star!)! - 1);
                    self.likeLB.text = self.model.star;
                    if self.starBlock != nil {
                        self.starBlock();
                    }
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            }
        } else {
            MZAPI.star(diaryID: self.model.diaryID) { (data, rmsg) in
                if rmsg == "ok" {
                    self.likeImageView.image = UIImage.init(named: "like_selected");
                    self.model.hasStar = "1";
                    self.model.star = String(Int(self.model.star!)! + 1);
                    self.likeLB.text = self.model.star;
                    if self.starBlock != nil {
                        self.starBlock();
                    }
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
