//
//  MZDiaryDetailCell.swift
//  diary
//
//  Created by 曾龙 on 2019/3/7.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit

class MZDiaryDetailCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var commentLB: UILabel!
    @IBOutlet weak var subCommentBgView: UIView!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    @IBOutlet weak var subCommentHeight: NSLayoutConstraint!
    
    var Height: CGFloat!
    
    var comment: ((_ commentID:String?) -> Void)!
    var showAllComments:((_ commentModel:MZCommentModel?) -> Void)!
    var showUserDetail:((_ userID:String?) -> Void)!
    
    var commentModel:MZCommentModel! {
        didSet {
            self.iconView!.sd_setImage(with: URL(string: commentModel.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
                
            })
            self.usernameLB.text = commentModel.username;
            self.timeLB.text = commentModel.commentTime!.getFormatterTimeString();
            self.commentLB.text = commentModel.content;
            
            let maxSize1 = CGSize.init(width: SCREEN_WIDTH-80, height: CGFloat.greatestFiniteMagnitude);
            let size1 = self.commentLB.sizeThatFits(maxSize1);
            if (size1.height > 20) {
                self.commentHeight.constant = size1.height;
            } else {
                self.commentHeight.constant = 20;
            }
            
            for (_, value) in self.subCommentBgView.subviews.enumerated() {
                value.removeFromSuperview();
            }
            
            var maxY:CGFloat = 0;
            
            if (commentModel.subCommentList?.count)! > 0 {
                if (commentModel.subCommentList?.count)! <= 2 {
                    for i in 0..<(commentModel.subCommentList?.count)! {
                        let subCommentLB = UILabel.init(frame: CGRect.init(x: 5, y: maxY+5, width: SCREEN_WIDTH-90, height: 18));
                        subCommentLB.numberOfLines = 0;
                        subCommentLB.isUserInteractionEnabled = true;
                        subCommentLB.font = UIFont.systemFont(ofSize: 14);
                        
                        let attributeString = NSMutableAttributedString.init();
                        let model = commentModel.subCommentList![i];
                        let name = NSAttributedString.init(string: model.username!, attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 0, g: 212, b: 71)]);
                        attributeString.append(name);
                        if (model.replyID != nil) {
                            attributeString.append(NSAttributedString.init(string: " 回复 "));
                            let replyName = NSAttributedString.init(string: model.replyName!, attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 0, g: 212, b: 71)]);
                            attributeString.append(replyName);
                        }
                        attributeString.append(NSAttributedString.init(string: " :\(model.content!)", attributes: [NSAttributedStringKey.foregroundColor: RGB(r: 51, g: 51, b: 51)]));
                        subCommentLB.attributedText = attributeString;
                        
                        let size = subCommentLB.sizeThatFits(CGSize.init(width: SCREEN_WIDTH-90, height: CGFloat.greatestFiniteMagnitude));
                        if size.height > 18 {
                            subCommentLB.frame = CGRect.init(x: 5, y: maxY+5, width: SCREEN_WIDTH-90, height: size.height);
                        }
                        if (model.replyID != nil) {
                            subCommentLB.lc_tapBlock = {(index, charAttributedString) in
                                if index < model.username!.count {
                                    if self.showUserDetail != nil {
                                        self.showUserDetail(model.userID);
                                    }
                                } else if (index < model.username!.count + 4 + model.replyName!.count && index >= model.username!.count + 4) {
                                    if self.showUserDetail != nil {
                                        self.showUserDetail(model.replyID);
                                    }
                                } else {
                                    if self.comment != nil {
                                        self.comment(model.commentID);
                                    }
                                }
                            }
                        } else {
                            subCommentLB.lc_tapBlock = {(index, charAttributedString) in
                                if index < model.username!.count {
                                    if self.showUserDetail != nil {
                                        self.showUserDetail(model.userID);
                                    }
                                } else {
                                    if self.comment != nil {
                                        self.comment(model.commentID);
                                    }
                                }
                            }
                        }
                        self.subCommentBgView.addSubview(subCommentLB);
                        maxY = subCommentLB.frame.maxY;
                    }
                } else {
                    for i in 0..<2 {
                        let subCommentLB = UILabel.init(frame: CGRect.init(x: 5, y: maxY+5, width: SCREEN_WIDTH-90, height: 18));
                        subCommentLB.numberOfLines = 0;
                        subCommentLB.isUserInteractionEnabled = true;
                        subCommentLB.font = UIFont.systemFont(ofSize: 14);
                        
                        let attributeString = NSMutableAttributedString.init();
                        let model = commentModel.subCommentList![i];
                        let name = NSAttributedString.init(string: model.username!, attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 0, g: 212, b: 71)]);
                        attributeString.append(name);
                        if (model.replyID != nil) {
                            attributeString.append(NSAttributedString.init(string: " 回复 "));
                            let replyName = NSAttributedString.init(string: model.replyName!, attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 0, g: 212, b: 71)]);
                            attributeString.append(replyName);
                        }
                        attributeString.append(NSAttributedString.init(string: " :\(model.content!)", attributes: [NSAttributedStringKey.foregroundColor: RGB(r: 51, g: 51, b: 51)]));
                        subCommentLB.attributedText = attributeString;
                        
                        let size = subCommentLB.sizeThatFits(CGSize.init(width: SCREEN_WIDTH-90, height: CGFloat.greatestFiniteMagnitude));
                        if size.height > 18 {
                            subCommentLB.frame = CGRect.init(x: 5, y: maxY+5, width: SCREEN_WIDTH-90, height: size.height);
                        }
                        if (model.replyID != nil) {
                            subCommentLB.lc_tapBlock = {(index, charAttributedString) in
                                if index < model.username!.count {
                                    if self.showUserDetail != nil {
                                        self.showUserDetail(model.userID);
                                    }
                                } else if (index < model.username!.count + 4 + model.replyName!.count && index >= model.username!.count + 4) {
                                    if self.showUserDetail != nil {
                                        self.showUserDetail(model.replyID);
                                    }
                                } else {
                                    if self.comment != nil {
                                        self.comment(model.commentID);
                                    }
                                }
                            }
                        } else {
                            subCommentLB.lc_tapBlock = {(index, charAttributedString) in
                                if index < model.username!.count {
                                    if self.showUserDetail != nil {
                                        self.showUserDetail(model.userID);
                                    }
                                } else {
                                    if self.comment != nil {
                                        self.comment(model.commentID);
                                    }
                                }
                            }
                        }
                        self.subCommentBgView.addSubview(subCommentLB);
                        maxY = subCommentLB.frame.maxY;
                    }
                    
                    let moreLB = UILabel.init(frame: CGRect.init(x: 5, y: maxY+5, width: SCREEN_WIDTH-90, height: 18));
                    moreLB.isUserInteractionEnabled = true;
                    moreLB.font = UIFont.systemFont(ofSize: 14);
                    moreLB.attributedText = NSAttributedString.init(string: "查看全部\((commentModel.subCommentList?.count)!)条评论", attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 136, g: 136, b: 136)]);
                    moreLB.lc_tapBlock = {(index, charAttributedString) in
                        if self.showAllComments != nil {
                            self.showAllComments(self.commentModel);
                        }
                    }
                    self.subCommentBgView.addSubview(moreLB);
                    maxY = moreLB.frame.maxY;
                }
                self.subCommentBgView.isHidden = false;
                self.subCommentHeight.constant = maxY+5;
                self.Height = 75+self.commentHeight.constant+self.subCommentHeight.constant;
            } else {
                self.subCommentBgView.isHidden = true;
                self.Height = 70+self.commentHeight.constant;
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commentLB.lc_tapBlock = {(index, charAttributedString) in
            if self.comment != nil {
                self.comment(self.commentModel.commentID);
            }
        }
        
        let iconTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        self.iconView.addGestureRecognizer(iconTap);
        let nameTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        self.usernameLB.addGestureRecognizer(nameTap);
    }
    
    
    @objc func tapClicked() -> Void {
        if self.showUserDetail != nil {
            self.showUserDetail(self.commentModel.userID);
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
