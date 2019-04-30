//
//  MZCommentDetailCell.swift
//  diary
//
//  Created by 曾龙 on 2019/4/30.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit

class MZCommentDetailCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var commentLB: UILabel!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    var Height:CGFloat!
    
    var comment: ((_ commentID:String?) -> Void)!
    var showUserDetail:((_ userID:String?) -> Void)!
    
    var commentModel:MZCommentModel! {
        didSet {
            self.iconView!.sd_setImage(with: URL(string: commentModel.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
                
            })
            self.nameLB.text = commentModel.username;
            self.timeLB.text = commentModel.commentTime!.getFormatterTimeString();
            
            if commentModel.replyID == nil{
                self.commentLB.text = commentModel.content;
                self.commentLB.lc_tapBlock = {(index, charAttributedString) in
                    if self.comment != nil {
                        self.comment(self.commentModel.commentID);
                    }
                }
            } else {
                let attributeText = NSMutableAttributedString.init(string: "回复 \(commentModel.replyName!) :\(commentModel.content!)");
                attributeText.setAttributes([NSAttributedStringKey.foregroundColor:RGB(r: 0, g: 212, b: 71)], range: NSRange.init(location: 3, length: commentModel.replyName!.count));
                self.commentLB.attributedText = attributeText;
                self.commentLB.lc_tapBlock = {(index, charAttributedString) in
                    if index > 2 && index < 3+(self.commentModel.replyName?.count)! {
                        if self.showUserDetail != nil {
                            self.showUserDetail(self.commentModel.replyID);
                        }
                    } else {
                        if self.comment != nil {
                            self.comment(self.commentModel.commentID);
                        }
                    }
                }
            }
            let maxSize1 = CGSize.init(width: SCREEN_WIDTH-80, height: CGFloat.greatestFiniteMagnitude);
            let size1 = self.commentLB.sizeThatFits(maxSize1);
            if (size1.height > 20) {
                self.commentHeight.constant = size1.height;
            } else {
                self.commentHeight.constant = 20;
            }
            
            self.Height = 70+self.commentHeight.constant;
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let iconTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        self.iconView.addGestureRecognizer(iconTap);
        let nameTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        self.nameLB.addGestureRecognizer(nameTap);
    }
    
    @objc func tapClicked() -> Void {
        if self.showUserDetail != nil {
            self.showUserDetail(self.commentModel.userID);
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
