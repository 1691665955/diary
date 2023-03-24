//
//  MZMainPageMutiCell.swift
//  diary
//
//  Created by 曾龙 on 2019/2/25.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZMainPageMutiCell: UITableViewCell {
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
    var previewImage:((_ imageViewList:[UIImageView], _ currentIndex:NSInteger) -> Void)!
    lazy var imageViewList:NSMutableArray = {
        let imageViewList = NSMutableArray();
        return imageViewList;
    }()
    
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
            
            self.imageViewList.removeAllObjects();
            for i in 0..<4 {
                let imageView = self.viewWithTag(10+i) as! UIImageView;
                if (i < model.images!.count) {
                    imageView.isHidden = false;
                    imageView.sd_setImage(with: URL.init(string: model.images![i] as! String)) { (image, error, cacheType, imageUrl) in
                        
                    }
                    self.imageViewList.add(imageView);
                } else {
                    imageView.isHidden = true;
                }
            }
            
            self.Height = 116 + self.contentHeight.constant + (SCREEN_WIDTH-14*5)/4;
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
        
        for i in 0..<4 {
            let imageView = self.viewWithTag(10+i) as! UIImageView;
            let imageTap = UITapGestureRecognizer.init(target: self, action: #selector(imagePreview));
            imageView.addGestureRecognizer(imageTap);
        }
    }

    @objc func tapClicked() -> Void {
        if self.showUserDetail != nil {
            self.showUserDetail(self.model.userID);
        }
    }
    
    @objc func imagePreview(tap:UITapGestureRecognizer) -> Void {
           if self.previewImage != nil {
               self.previewImage(self.imageViewList as! [UIImageView], tap.view!.tag-10);
           }
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
}
