//
//  MZPersonCenterVC.swift
//  diary
//
//  Created by 曾龙 on 2019/3/1.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZPersonCenterVC: MZFatherController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nicknameLB: UILabel!
    @IBOutlet weak var mobileLB: UILabel!
    var userModel: MZUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的";
        self.logoutBtn.layer.borderColor = RGB(r: 104, g: 104, b: 104).cgColor;
        
        self.tableView.tableFooterView?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 84);
        self.tableView.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 80);
        
        self.tableView.register(UINib.init(nibName: "MZPersonCenterCell", bundle: nil), forCellReuseIdentifier: "MZPersonCenterCell");
        
        MZAPI.personCenter { (data, rmsg) in
            if rmsg == "ok" {
                self.userModel = MZUser.deserialize(from: data);
                self.loadHeader();
            } else {
                MBProgressHUD.showError(error: rmsg);
            }
        }
    }
    
    //获取我的详细信息
    @IBAction func getMyInfo(_ sender: UITapGestureRecognizer) {
        let myInfoVC = MZMyInfoVC.init(nibName: "MZMyInfoVC", bundle: nil);
        myInfoVC.hidesBottomBarWhenPushed = true;
        myInfoVC.userModel = self.userModel;
        myInfoVC.updateAvaterSuccess = { avatar in
            self.avatarView.image = avatar;
        }
        myInfoVC.updateUsernameSuccess = { username in
            self.nicknameLB.text = username;
        }
        self.navigationController?.pushViewController(myInfoVC, animated: true);
    }
    
    //退出登录
    @IBAction func logout(_ sender: UIButton) {
        let title = NSAttributedString.init(string: "提示", attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 153, g: 153, b: 153)]);
        let alert = UIAlertController.init(title: nil, message: "是否确认退出登录？", preferredStyle: UIAlertControllerStyle.alert);
        alert.setValue(title, forKey: "attributedTitle");
        let confirmAction = UIAlertAction.init(title: "确认", style: UIAlertActionStyle.default) { (action) in
            let defaults = UserDefaults.standard;
            defaults.removeObject(forKey: "token");
            defaults.synchronize();
            
            let leadingVC = MZLeadingVC();
            let nvc = MZNavigationController.init(rootViewController: leadingVC);
            UIApplication.shared.keyWindow?.rootViewController = nvc;
        };
        confirmAction.setValue(RGB(r: 0, g: 212, b: 71), forKey: "titleTextColor");
        alert.addAction(confirmAction);
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        };
        cancelAction.setValue(RGB(r: 136, g: 136, b: 136), forKey: "titleTextColor");
        alert.addAction(cancelAction);
        self.present(alert, animated: true, completion: nil);
    }
    
    //加载header
    func loadHeader() -> Void {
        self.avatarView.sd_setImage(with: URL(string: self.userModel.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: { (image, error, cacheType, imageURL) in
            
        })
        self.nicknameLB.text = self.userModel.username;
        self.mobileLB.text = self.userModel.mobile;
    }
    
    //MARK:-UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MZPersonCenterCell") as! MZPersonCenterCell;
        cell.type = MZPersonCenterCellType(rawValue: indexPath.row);
        return cell;
    }
    
    //MARK:-UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = MZModifyPasswordVC.init(nibName: "MZModifyPasswordVC", bundle: nil);
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        } else if indexPath.row == 1 {
            let vc = MZHistoryDiaryVC.init(nibName: "MZHistoryDiaryVC", bundle: nil);
            vc.type = MZDiaryListType.history;
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        } else if indexPath.row == 2 {
            let vc = MZHistoryDiaryVC.init(nibName: "MZHistoryDiaryVC", bundle: nil);
            vc.type = MZDiaryListType.star;
            vc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
}
