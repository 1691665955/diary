//
//  MZCommentDetailVC.swift
//  diary
//
//  Created by 曾龙 on 2019/4/30.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MZExtension
import IQKeyboardManager
import MBProgressHUD

class MZCommentDetailVC: MZActionSheetController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var commentView: IQTextView!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var distrubuteBtn: UIButton!
    @IBOutlet weak var commentViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var followLB: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var commentCountLB: UILabel!
    
    @IBOutlet weak var header1: UIView!
    @IBOutlet weak var header2: UIView!
    
    var commentModel:MZCommentModel!
    var commentID: String!
    var updateData:(() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        self.tableViewBottom.constant = Safe_Bottom+40;
        self.commentViewBottom.constant = Safe_Bottom;
        self.commentView.layoutManager.allowsNonContiguousLayout = false;
        
        self.height = SCREEN_HEIGHT-StateBar_Height;
        
        self.tableView.register(UINib.init(nibName: "MZCommentDetailCell", bundle: nil), forCellReuseIdentifier: "MZCommentDetailCell");
        
        self.avatarView!.sd_setImage(with: URL(string: self.commentModel.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
            
        })
        self.userNameLB.text = self.commentModel.username;
        self.commentCountLB.text = "\(self.commentModel.subCommentList?.count ?? 0)条回复"
        
        self.commentID = self.commentModel.commentID;
        
        let tableHeaderView = UIView.init();
        let iconView = UIImageView.init(frame: CGRect.init(x: 14, y: 10, width: 40, height: 40));
        iconView.sd_setImage(with: URL(string: self.commentModel.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
            
        })
        iconView.layer.cornerRadius = 20;
        iconView.layer.masksToBounds = true;
        tableHeaderView.addSubview(iconView);
        let nameLB = UILabel.init(frame: CGRect.init(x: 66, y: 10, width: 10, height: 22.5));
        nameLB.textColor = RGB(r: 0, g: 212, b: 71);
        nameLB.font = UIFont.systemFont(ofSize: 18);
        nameLB.text = self.commentModel.username;
        var maxSize = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 22.5);
        var size = nameLB.sizeThatFits(maxSize);
        nameLB.frame = CGRect.init(x: 66, y: 10, width: size.width, height: 22.5);
        tableHeaderView.addSubview(nameLB);
        
        let iconTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        iconView.addGestureRecognizer(iconTap);
        let nameTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        nameLB.addGestureRecognizer(nameTap);
        
        let timeLB = UILabel.init(frame: CGRect.init(x: 66, y: 33.5, width: 200, height: 16.5));
        timeLB.textColor = RGB(r: 136, g: 136, b: 136);
        timeLB.font = UIFont.systemFont(ofSize: 14);
        timeLB.text = self.commentModel.commentTime!.getFormatterTimeString();
        tableHeaderView.addSubview(timeLB);
        
        let followBtn = UIButton.init(type: UIButtonType.custom);
        followBtn.frame = CGRect.init(x: SCREEN_WIDTH-60, y: 17.5, width: 50, height: 25);
        followBtn.backgroundColor = RGB(r: 229, g: 89, b: 89);
        followBtn.layer.cornerRadius = 4;
        followBtn.layer.masksToBounds = true;
        followBtn.setTitle("关注", for: .normal);
        followBtn.setTitleColor(UIColor.white, for: .normal);
        followBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        followBtn.addTarget(self, action: #selector(follow), for: .touchUpInside);
        tableHeaderView.addSubview(followBtn);
        
        let commentLB = UILabel.init(frame: CGRect.init(x: 66, y: 60, width: SCREEN_WIDTH-80, height: 20));
        commentLB.numberOfLines = 0;
        commentLB.font = UIFont.systemFont(ofSize: 16);
        commentLB.text = self.commentModel.content;
        maxSize = CGSize.init(width: SCREEN_WIDTH-80, height: CGFloat.greatestFiniteMagnitude);
        size = commentLB.sizeThatFits(maxSize);
        commentLB.frame = CGRect.init(x: 66, y: 60, width: SCREEN_WIDTH-80, height: size.height);
        tableHeaderView.addSubview(commentLB);
        let line = UIView.init(frame: CGRect.init(x: 0, y: commentLB.frame.maxY+10, width: SCREEN_WIDTH, height: 1));
        line.backgroundColor = RGB(r: 223, g: 223, b: 223);
        tableHeaderView.addSubview(line);
        
        let tipLB = UILabel.init(frame: CGRect.init(x: 14, y: line.frame.maxY+10, width: 200, height: 16.5));
        tipLB.text = "全部评论";
        tipLB.textColor = RGB(r: 136, g: 136, b: 136);
        tipLB.font = UIFont.systemFont(ofSize: 14);
        tableHeaderView.addSubview(tipLB);
        
        
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: tipLB.frame.maxY);
        self.tableView.tableHeaderView = tableHeaderView;
        
    }
    
    //返回
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    //关注
    @IBAction func follow(_ sender: Any) {
    }
    
    @objc func tapClicked() -> Void {
        self.showUserDetail(userID: self.commentModel.userID);
    }
    
    @objc func showUserDetail(userID:String?) -> Void {
        print("查看用户详情")
    }
    
    //发布
    @IBAction func distrubute(_ sender: UIButton) {
        MBProgressHUD.showMessage(message: "");
        MZAPI.commentDiary(diaryID: self.commentModel.diaryID, content: self.commentView.text, commentID: self.commentID) { (data, rmsg) in
            MBProgressHUD.hideHUD();
            if rmsg == "ok" {
                let newComment = MZCommentModel.deserialize(from: data!["comment"] as? NSDictionary);
                var subCommentList = self.commentModel.subCommentList;
                subCommentList?.append(newComment!);
                self.commentModel.subCommentList = subCommentList;
                self.tableView.reloadData();
                self.tableView.scrollToRow(at: IndexPath.init(row: self.commentModel.subCommentList!.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true);
                
                self.commentView.text = "";
                self.textViewDidChange(self.commentView);
                self.commentView.resignFirstResponder();
                self.commentID = self.commentModel.commentID;
                self.commentCountLB.text = "\(self.commentModel.subCommentList?.count ?? 0)条回复";
                if self.updateData != nil {
                    self.updateData();
                }
            } else {
                MBProgressHUD.showError(error: rmsg);
                self.commentView.text = "";
                self.textViewDidChange(self.commentView);
                self.commentView.resignFirstResponder();
                self.commentID = self.commentModel.commentID;
            }
        }
    }
    
    //MARK:-UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.commentModel.subCommentList?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MZCommentDetailCell") as! MZCommentDetailCell;
        cell.commentModel = self.commentModel.subCommentList?[indexPath.row];
        cell.comment = { commentID in
            self.commentID = commentID;
            self.commentView.becomeFirstResponder();
        };
        cell.showUserDetail = { userID in
            self.showUserDetail(userID: userID);
        }
        return cell;
    }
    
    //MARK:-UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! MZCommentDetailCell;
        return cell.Height;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            self.commentView.text = "";
            self.textViewDidChange(self.commentView);
            self.commentView.resignFirstResponder();
            
            if scrollView.contentOffset.y > 50 {
                self.header1.isHidden = true;
                self.header2.isHidden = false;
            } else {
                self.header1.isHidden = false;
                self.header2.isHidden = true;
            }
        }
    }
    
    //MARK:-UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            self.distrubuteBtn.isEnabled = true;
        } else {
            self.distrubuteBtn.isEnabled = false;
        }
        let size = textView.sizeThatFits(CGSize.init(width: SCREEN_WIDTH-78, height: CGFloat.greatestFiniteMagnitude));
        if size.height > 30 {
            self.commentViewHeight.constant = size.height;
        } else {
            self.commentViewHeight.constant = 30;
        }
        textView.layoutIfNeeded();
        IQKeyboardManager.shared().reloadLayoutIfNeeded();
    }
    
    //MARK:-NotificationCenter
    @objc func keyboardWillShow(notification:NSNotification) -> Void {
        let keyboardInfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey];
        let keyboardHeight:CGFloat = ((keyboardInfo as AnyObject).cgRectValue.size.height);
        self.commentViewBottom.constant = keyboardHeight;
    }
    
    @objc func keyboardWillHide(notification:NSNotification) -> Void {
        self.commentViewBottom.constant = Safe_Bottom;
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        IQKeyboardManager.shared().isEnabled = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        IQKeyboardManager.shared().isEnabled = true;
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.view.setRounded(corners: UIRectCorner.topLeft.union(UIRectCorner.topRight), radii: CGSize.init(width: 10, height: 10));
    }
}
