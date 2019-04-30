//
//  MZLoginVC.swift
//  diary
//
//  Created by 曾龙 on 2018/7/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZLoginVC: MZFatherController,UITextFieldDelegate {
    @IBOutlet weak var pwdLoginBtn: UIButton!
    @IBOutlet weak var codeLoginBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var getCodeBtn:UIButton!
    var timer:Timer!
    var countDown:NSInteger!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登录";
        let leftView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 10));
        self.mobileTF.leftViewMode = UITextFieldViewMode.always;
        self.mobileTF.leftView = leftView1;
        
        let leftView2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 10));
        self.passwordTF.leftViewMode = UITextFieldViewMode.always;
        self.passwordTF.leftView = leftView2;
        
        
    }

    @objc func getCode() -> Void {
        if self.noneSpaseString(string: self.mobileTF.text)?.isPhoneNum() == false {
            MBProgressHUD.showError(error: "请输入正确的手机号码");
            return;
        }
        MZAPI.getCode(mobile: self.noneSpaseString(string: self.mobileTF.text), type: 2) { (data, rmsg) in
            if rmsg == "ok" {
                self.countDown = 60;
                self.getCodeBtn.isEnabled = false;
                self.getCodeBtn.setTitle(String.init(format: "%ldS", self.countDown), for: UIControlState.normal);
                if self.timer == nil {
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeFun), userInfo: nil, repeats: true);
                    self.timer.fire();
                } else {
                    self.timer.fireDate = Date.distantPast;
                }
            } else {
                MBProgressHUD.showError(error: rmsg);
            }
        }
    }
    
    //切换密码登录
    @IBAction func pwdLogin(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            var center:CGPoint = self.lineView.center;
            center.x = self.pwdLoginBtn.center.x;
            self.lineView.center = center;
        }) { (finished) in
            self.pwdLoginBtn.isSelected = true;
            self.codeLoginBtn.isSelected = false;
            self.passwordTF.text = "";
            self.passwordTF.placeholder = "请输入密码";
            
            self.passwordTF.rightViewMode = UITextFieldViewMode.always;
            self.passwordTF.rightView = nil;
        }
    }
    
    //切换验证码登录
    @IBAction func codeLogin(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            var center:CGPoint = self.lineView.center;
            center.x = self.codeLoginBtn.center.x;
            self.lineView.center = center;
        }) { (finished) in
            self.codeLoginBtn.isSelected = true;
            self.pwdLoginBtn.isSelected = false;
            self.passwordTF.text = "";
            self.passwordTF.placeholder = "请输入验证码";
            
            let rightView = UIButton.init(type: UIButtonType.custom);
            rightView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 60);
            rightView.setTitle("获取验证码", for: UIControlState.normal);
            rightView.setTitleColor(RGB(r: 0, g: 212, b: 71), for: UIControlState.normal);
            rightView.titleLabel?.font = UIFont.systemFont(ofSize: 14);
            rightView.addTarget(self, action: #selector(self.getCode), for: UIControlEvents.touchUpInside);
            self.passwordTF.rightViewMode = UITextFieldViewMode.always;
            self.passwordTF.rightView = rightView;
            self.getCodeBtn = rightView;
        }
    }
    
    //登录
    @IBAction func login(_ sender: Any) {
        if self.noneSpaseString(string: self.mobileTF.text)?.isPhoneNum() == false {
            MBProgressHUD.showError(error: "请输入正确的手机号码");
            return;
        }
        if self.codeLoginBtn.isSelected {
            if self.passwordTF.text?.count != 6 {
                MBProgressHUD.showError(error: "请输入正确的验证码");
                return;
            }
            MZAPI.loginByCode(mobile: self.noneSpaseString(string: self.mobileTF.text), code: self.passwordTF.text, callback: { (data, rmsg) in
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
            })
        } else {
            if (self.passwordTF.text?.count)! < 6 || (self.passwordTF.text?.count)! > 20 {
                MBProgressHUD.showError(error: "请输入正确的密码");
                return;
            }
            MZAPI.loginByPassword(mobile: self.noneSpaseString(string: self.mobileTF.text), password: self.passwordTF.text, callback: { (data, rmsg) in
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
            })
        }
    }
    
    //忘记密码
    @IBAction func forgetPwd(_ sender: Any) {
        
    }
    
    @objc func timeFun() -> Void {
        self.countDown = self.countDown-1;
        if self.countDown == 0 {
            self.getCodeBtn.isEnabled = true;
            self.getCodeBtn.setTitle("获取验证码", for: UIControlState.normal);
            self.timer.fireDate = Date.distantFuture;
        } else {
            self.getCodeBtn.setTitle(String.init(format: "%ldS", self.countDown), for: UIControlState.normal);
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.mobileTF {
            let text:String! = textField.text;
            if (text == "") {
                if range.length == 1 {
                    //最后一位,遇到空格则多删除一次
                    if range.location == (text?.count)!-1 {
                        if (String(text[text.endIndex...]) == " ") {
                            textField.deleteBackward();
                        }
                        return true;
                    } else {
                        //从中间删除
                        var offset = range.location;
                        if range.location < text.count && String(text[text.endIndex...]) == " " && (textField.selectedTextRange?.isEmpty)! {
                            textField.deleteBackward();
                            offset = offset-1;
                        }
                        textField.deleteBackward();
                        textField.text = self.parseString(string: textField.text!);
                        let newPos = textField.position(from: textField.beginningOfDocument, offset: offset);
                        textField.selectedTextRange = textField.textRange(from: newPos!, to: newPos!);
                        return false;
                    }
                } else if range.length > 1 {
                    var isLast = false;
                    //如果是从最后一位开始
                    if range.location + range.length == textField.text?.count {
                        isLast = true;
                    }
                    textField.deleteBackward();
                    textField.text = self.parseString(string: textField.text);
                    
                    var offset = range.location;
                    if range.location == 3 || range.location == 8 {
                        offset = offset + 1;
                    }
                    if isLast {
                        //光标直接在最后一位了
                    } else {
                        let newPos = textField.position(from: textField.beginningOfDocument, offset: offset);
                        textField.selectedTextRange = textField.textRange(from: newPos!, to: newPos!);
                    }
                    return false;
                } else {
                    return true;
                }
            } else if string.count > 0 {
                //限制输入字符个数
                if ((self.noneSpaseString(string: textField.text)?.count)! + string.count-range.length > 11) {
                    return false;
                }
                textField.insertText(string);
                textField.text = self.parseString(string: textField.text);
                var offset = range.location+string.count;
                if range.location == 3 || range.location == 8 {
                    offset = offset + 1;
                }
                let newPos = textField.position(from: textField.beginningOfDocument, offset: offset);
                textField.selectedTextRange = textField.textRange(from: newPos!, to: newPos!);
                return false;
            } else {
                return true;
            }
        } else {
            if string.count > 0 {
                if (textField.text?.count)!+string.count-range.length > 6 && self.codeLoginBtn.isSelected {
                    return false;
                }
                if (textField.text?.count)!+string.count-range.length > 20 && self.pwdLoginBtn.isSelected {
                    return false;
                }
            }
        }
        return true;
    }
    
    func noneSpaseString(string:String?) -> String? {
        if string == nil {
            return nil;
        }
        return string?.replacingOccurrences(of: " ", with: "");
    }
    
    func parseString(string:String?) -> String? {
        if string == nil {
            return nil;
        }
        var mStr:String = self.noneSpaseString(string: string)!;
        if mStr.count > 3 {
            mStr.insert(" ", at: mStr.index(mStr.startIndex, offsetBy: 3));
        }
        if mStr.count > 8 {
            mStr.insert(" ", at: mStr.index(mStr.startIndex, offsetBy: 8));
        }
        return mStr;
    }
}
