//
//  MZEidtUsernameVC.swift
//  diary
//
//  Created by 曾龙 on 2019/3/2.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZEidtUsernameVC: MZFatherController {
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    var updateUsernameSuccess:((_ username:String?) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改昵称";
        
    }

    @IBAction func confirm(_ sender: UIButton) {
        if self.usernameTF.text?.count == 0 {
            MBProgressHUD.showError(error: "请输入昵称");
            return;
        }
    
        MZAPI.updateUsername(username: self.usernameTF.text) { (data, rmsg) in
            if rmsg == "ok" {
                MBProgressHUD.showSuccess(success: "修改成功");
                if (self.updateUsernameSuccess != nil) {
                    self.updateUsernameSuccess(self.usernameTF.text);
                }
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
