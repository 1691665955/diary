//
//  MZModifyPasswordVC.swift
//  diary
//
//  Created by 曾龙 on 2019/3/2.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZModifyPasswordVC: MZFatherController {
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var againPassswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码";
    }

    @IBAction func confirm(_ sender: UIButton) {
        if self.oldPasswordTF.text?.count == 0 {
            MBProgressHUD.showError(error: "请输入原密码");
            return;
        }
        
        if self.newPasswordTF.text?.count == 0 {
            MBProgressHUD.showError(error: "请输入新密码");
            return;
        }
        
        if self.againPassswordTF.text?.count == 0 {
            MBProgressHUD.showError(error: "请再次输入新密码");
            return;
        }
        
        if self.againPassswordTF.text !=  self.newPasswordTF.text {
            MBProgressHUD.showError(error: "两次输入新密码不一致");
            return;
        }
        
        MZAPI.resetPassword(password: self.newPasswordTF.text, oldPassword: self.oldPasswordTF.text) { (data, rmsg) in
            if rmsg == "ok" {
                MBProgressHUD.showSuccess(success: "修改成功");
                self.perform(#selector(self.back), with: nil, afterDelay: 2.0);
            } else {
                MBProgressHUD.showError(error: rmsg);
            }
        }
    }
    
    @objc func back() -> Void {
        self.navigationController?.popViewController(animated: true);
    }
}
