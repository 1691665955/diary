//
//  MZSetupPasswordVC.swift
//  diary
//
//  Created by 曾龙 on 2018/7/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZSetupPasswordVC: MZFatherController {

    @IBOutlet weak var passwordTF: UITextField!
    var mobile:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置密码";
    }

    @IBAction func finish(_ sender: Any) {
        if (self.passwordTF.text?.count)! < 6 {
            MBProgressHUD.showError(error: "请按要求输入密码");
            return;
        }
        MZAPI.register(mobile: self.mobile, password: self.passwordTF.text) { (data, rmsg) in
            if rmsg == "ok" {
                let token = data?.value(forKey: "token");
                let userDefaults = UserDefaults.standard;
                userDefaults.set(token, forKey: "token");
                userDefaults.synchronize();
                let vc = MZTabbarController();
                UIApplication.shared.keyWindow?.rootViewController = vc;
            } else {
                MBProgressHUD.showError(error: rmsg);
            }
        }
    }
}
