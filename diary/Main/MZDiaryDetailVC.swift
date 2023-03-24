//
//  MZDiaryDetailVC.swift
//  diary
//
//  Created by 曾龙 on 2019/3/7.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
import IQKeyboardManager
import MZExtension

class MZDiaryDetailVC: MZFatherController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    @IBOutlet weak var distributeBtn: UIButton!
    @IBOutlet weak var commentView: IQTextView!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    lazy var commentList:NSMutableArray = {
        let commentList = NSMutableArray();
        return commentList;
    }()
    lazy var imageViewList:NSMutableArray = {
        let imageViewList = NSMutableArray();
        return imageViewList;
    }()
    var pageNum:NSInteger!
    var model: MZDiaryModel!
    var commentID: String!
    
    var updateData:(() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "日记正文";
        self.tableViewBottom.constant = Safe_Bottom+40;
        self.commentBottom.constant = Safe_Bottom;
        self.commentView.layoutManager.allowsNonContiguousLayout = false;
        
        let rightItem = UIBarButtonItem.init(image: UIImage.init(named:"like"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(like));
        rightItem.tintColor = self.model.hasStar == "1" ? RGB(r: 229, g: 89, b: 89) : UIColor.white;
        self.navigationItem.rightBarButtonItem = rightItem;
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        self.loadTableViewHeader();
        
        self.tableView.register(UINib.init(nibName: "MZDiaryDetailCell", bundle: nil), forCellReuseIdentifier: "MZDiaryDetailCell");
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNew));
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore));
        self.tableView.mj_header.beginRefreshing();
    }
    
    @objc func like() -> Void {
        if self.model.hasStar == "1" {
            MZAPI.cancelStar(diaryID: self.model.diaryID) { (data, rmsg) in
                if rmsg == "ok" {
                    self.model.hasStar = "0";
                    self.model.star = String(Int(self.model.star!)! - 1);
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white;
                    if self.updateData != nil {
                        self.updateData();
                    }
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            }
        } else {
            MZAPI.star(diaryID: self.model.diaryID) { (data, rmsg) in
                if rmsg == "ok" {
                    self.model.hasStar = "1";
                    self.model.star = String(Int(self.model.star!)! + 1);
                    self.navigationItem.rightBarButtonItem?.tintColor = RGB(r: 229, g: 89, b: 89);
                    if self.updateData != nil {
                        self.updateData();
                    }
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            }
        }
    }
    
    func loadTableViewHeader() -> Void {
        let header = UIView.init();
        
        let iconView = UIImageView.init(frame: CGRect.init(x: 14, y: 10, width: 40, height: 40));
        iconView.sd_setImage(with: URL(string: self.model.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
            
        })
        iconView.layer.cornerRadius = 20;
        iconView.layer.masksToBounds = true;
        header.addSubview(iconView);
        
        let nameLB = UILabel.init(frame: CGRect.init(x: 66, y: 10, width: SCREEN_WIDTH-80, height: 20));
        nameLB.font = UIFont.systemFont(ofSize: 18);
        nameLB.textColor = RGB(r: 0, g: 212, b: 71);
        nameLB.text = self.model.username;
        header.addSubview(nameLB);
        
        let iconTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        iconView.addGestureRecognizer(iconTap);
        let nameTap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked));
        nameLB.addGestureRecognizer(nameTap);
        
        let timeLB = UILabel.init(frame: CGRect.init(x: 66, y: 31, width: SCREEN_WIDTH-80, height: 16.5));
        timeLB.font = UIFont.systemFont(ofSize: 14);
        timeLB.textColor = RGB(r: 136, g: 136, b: 136);
        timeLB.text = self.model.time!.getFormatterTimeString();
        header.addSubview(timeLB);
        
        let followBtn = UIButton.init(type: UIButtonType.custom);
        followBtn.frame = CGRect.init(x: SCREEN_WIDTH-60, y: 17.5, width: 50, height: 25);
        followBtn.backgroundColor = RGB(r: 229, g: 89, b: 89);
        followBtn.layer.cornerRadius = 4;
        followBtn.layer.masksToBounds = true;
        followBtn.setTitle("关注", for: .normal);
        followBtn.setTitleColor(UIColor.white, for: .normal);
        followBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        followBtn.addTarget(self, action: #selector(follow), for: .touchUpInside);
        header.addSubview(followBtn);
        
        var maxY:CGFloat = 0;
        
        if self.model.type == "1" {
            let contentLB = UILabel.init(frame: CGRect.init(x: 14, y: iconView.frame.maxY+8, width: SCREEN_WIDTH-28, height: 20));
            contentLB.numberOfLines = 0;
            contentLB.font = UIFont.systemFont(ofSize: 16);
            contentLB.text = self.model.content;
            
            let size = contentLB.sizeThatFits(CGSize.init(width: SCREEN_WIDTH-28, height: CGFloat.greatestFiniteMagnitude));
            if size.height > 20 {
                contentLB.frame = CGRect.init(x: 14, y: iconView.frame.maxY+8, width: SCREEN_WIDTH-28, height: size.height);
            }
            header.addSubview(contentLB);
            maxY = contentLB.frame.maxY;
        } else if self.model.type == "2" {
            for i in 0..<(self.model.images?.count)! {
                let imageView = UIImageView.init(frame: CGRect.init(x: 40, y: iconView.frame.maxY+8+(SCREEN_WIDTH-80+8)*CGFloat(i), width: SCREEN_WIDTH-80, height: SCREEN_WIDTH-80));
                imageView.sd_setImage(with: URL.init(string: self.model.images![i] as! String)) { (image, error, cacheType, imageUrl) in
                    
                }
                
                imageView.isUserInteractionEnabled = true;
                imageView.tag = 10+i;
                let imageTap = UITapGestureRecognizer.init(target: self, action: #selector(imagePreview));
                imageView.addGestureRecognizer(imageTap);
                self.imageViewList.add(imageView);
                
                header.addSubview(imageView);
                maxY = imageView.frame.maxY;
            }
        } else {
            let contentLB = UILabel.init(frame: CGRect.init(x: 14, y: iconView.frame.maxY+8, width: SCREEN_WIDTH-28, height: 20));
            contentLB.numberOfLines = 0;
            contentLB.font = UIFont.systemFont(ofSize: 16);
            contentLB.text = self.model.content;
            
            let size = contentLB.sizeThatFits(CGSize.init(width: SCREEN_WIDTH-28, height: CGFloat.greatestFiniteMagnitude));
            if size.height > 20 {
                contentLB.frame = CGRect.init(x: 14, y: iconView.frame.maxY+8, width: SCREEN_WIDTH-28, height: size.height);
            }
            header.addSubview(contentLB);
            
            for i in 0..<(self.model.images?.count)! {
                let imageView = UIImageView.init(frame: CGRect.init(x: 40, y: contentLB.frame.maxY+8+(SCREEN_WIDTH-80+8)*CGFloat(i), width: SCREEN_WIDTH-80, height: SCREEN_WIDTH-80));
                imageView.sd_setImage(with: URL.init(string: self.model.images![i] as! String)) { (image, error, cacheType, imageUrl) in
                    
                }
                
                imageView.isUserInteractionEnabled = true;
                imageView.tag = 10+i;
                let imageTap = UITapGestureRecognizer.init(target: self, action: #selector(imagePreview));
                imageView.addGestureRecognizer(imageTap);
                self.imageViewList.add(imageView);
                
                header.addSubview(imageView);
                maxY = imageView.frame.maxY;
            }
        }
        
        let line1 = UIView.init(frame: CGRect.init(x: 0, y: maxY+5, width: SCREEN_WIDTH, height: 5));
        line1.backgroundColor = RGB(r: 245, g: 245, b: 245);
        header.addSubview(line1);
        
        let tip = UILabel.init(frame: CGRect.init(x: 14, y: line1.frame.maxY, width: 200, height: 40));
        tip.text = "全部评论";
        tip.font = UIFont.systemFont(ofSize: 18);
        header.addSubview(tip);
        
        let line2 = UIView.init(frame: CGRect.init(x: 0, y: tip.frame.maxY, width: SCREEN_WIDTH, height: 1));
        line2.backgroundColor = RGB(r: 223, g: 223, b: 223);
        header.addSubview(line2);
        
        header.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: line2.frame.maxY);
        self.tableView.tableHeaderView = header;
    }
    
    @objc func tapClicked() -> Void {
        self.showUserDetail(userID: self.model.userID);
    }
    
    @objc func showUserDetail(userID:String?) -> Void {
        print("查看用户详情")
    }
    
    @objc func follow() -> Void {
        
    }
    
    @objc func imagePreview(tap:UITapGestureRecognizer) -> Void {
        let imageBrowsingVC = MZImageBrowsingVC.init(imageViewArray: self.imageViewList as? [UIImageView], currentIndex: tap.view!.tag-10);
        self.present(imageBrowsingVC!, animated: true, completion: nil);
    }
    
    @objc func loadNew() -> Void {
        self.pageNum = 1;
        self.loadData();
    }
    
    @objc func loadMore() -> Void {
        self.pageNum += 1;
        self.loadData();
    }
    
    func loadData() -> Void {
        MZAPI.getCommentList(pageNum: self.pageNum, pageSize: "20", diaryID: self.model.diaryID) { (data, rmsg) in
            if (self.pageNum == 1) {
                self.tableView.mj_header.endRefreshing();
            } else {
                self.tableView.mj_footer.endRefreshing();
            }
            
            if rmsg == "ok" {
                if (self.pageNum == 1) {
                    self.commentList.removeAllObjects();
                }
                let array:[NSDictionary] = data?.value(forKey: "commentList") as! [NSDictionary];
                for i in 0 ..< array.count {
                    if let model = MZCommentModel.deserialize(from: (array[i])) {
                        self.commentList.add(model);
                    };
                }
                self.tableView.reloadData();
            } else {
                MBProgressHUD.showError(error: rmsg);
            }
        }
    }
    
    //MARK:-UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MZDiaryDetailCell") as! MZDiaryDetailCell;
        cell.commentModel = (self.commentList[indexPath.row] as! MZCommentModel);
        cell.comment = { commentID in
            self.commentID = commentID;
            self.commentView.becomeFirstResponder();
        };
        cell.showAllComments = { commentModel in
            let commentDetailVC = MZCommentDetailVC.init(nibName: "MZCommentDetailVC", bundle: nil);
            commentDetailVC.commentModel = commentModel;
            commentDetailVC.updateData = {
                self.tableView.reloadData();
            }
            self.present(commentDetailVC, animated: true, completion: nil);
        };
        cell.showUserDetail = { userID in
            self.showUserDetail(userID: userID);
        }
        return cell;
    }
    
    //MARK:-UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! MZDiaryDetailCell;
        return cell.Height;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            self.commentView.text = "";
            self.textViewDidChange(self.commentView);
            self.commentView.resignFirstResponder();
        }
    }
    
    //MARK:-UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            self.distributeBtn.isEnabled = true;
        } else {
            self.distributeBtn.isEnabled = false;
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
        self.commentBottom.constant = keyboardHeight;
    }
    
    @objc func keyboardWillHide(notification:NSNotification) -> Void {
        self.commentBottom.constant = Safe_Bottom;
    }
    
    @IBAction func distribute(_ sender: UIButton) {
        MBProgressHUD.showMessage(message: "");
        MZAPI.commentDiary(diaryID: self.model.diaryID, content: self.commentView.text, commentID: self.commentID) { (data, rmsg) in
            MBProgressHUD.hideHUD();
            if rmsg == "ok" {
                let newComment = MZCommentModel.deserialize(from: data!["comment"] as? NSDictionary);
                if self.commentID != nil {
                    for item in self.commentList {
                        let comment = item as! MZCommentModel
                        if self.commentID == comment.commentID {
                            var subCommentList = comment.subCommentList;
                            subCommentList?.append(newComment!);
                            comment.subCommentList = subCommentList;
                            self.tableView.reloadData();
                        }
                        for subItem in comment.subCommentList! {
                            if self.commentID == subItem.commentID {
                                var subCommentList = comment.subCommentList;
                                subCommentList?.append(newComment!);
                                comment.subCommentList = subCommentList;
                                self.tableView.reloadData();
                            }
                        }
                    }
                } else {
                    self.commentList.add(newComment as Any);
                    self.tableView.reloadData();
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.commentList.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true);
                }
                
                self.commentView.text = "";
                self.textViewDidChange(self.commentView);
                self.commentView.resignFirstResponder();
                self.commentID = nil;
            } else {
                MBProgressHUD.showError(error: rmsg);
                self.commentView.text = "";
                self.textViewDidChange(self.commentView);
                self.commentView.resignFirstResponder();
                self.commentID = nil;
            }
        }
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
}
