//
//  MZRegisterVC.swift
//  diary
///Users/cenglong/Desktop/diary/diary
//  Created by 曾龙 on 2018/7/15.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD

class MZRegisterVC: MZFatherController,UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    var getCodeBtn:UIButton!
    var timer:Timer!
    var countDown:NSInteger!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册";
        let leftView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 10));
        self.phoneNumTF.leftViewMode = UITextFieldViewMode.always;
        self.phoneNumTF.leftView = leftView1;
        
        let leftView2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 10));
        self.codeTF.leftViewMode = UITextFieldViewMode.always;
        self.codeTF.leftView = leftView2;

        let rightView = UIButton.init(type: UIButtonType.custom);
        rightView.frame = CGRect.init(x: 0, y: 0, width: 80, height: self.codeTF.frame.height);
        rightView.setTitle("获取验证码", for: UIControlState.normal);
        rightView.setTitleColor(RGB(r: 0, g: 212, b: 71), for: UIControlState.normal);
        rightView.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        rightView.addTarget(self, action: #selector(getCode), for: UIControlEvents.touchUpInside);
        self.codeTF.rightViewMode = UITextFieldViewMode.always;
        self.codeTF.rightView = rightView;
        self.getCodeBtn = rightView;
    }
    
    @IBAction func register(_ sender: UIButton) {
        if self.noneSpaseString(string: self.phoneNumTF.text)?.isPhoneNum() == false {
            MBProgressHUD.showError(error: "请输入正确的手机号码");
            return;
        }
        if self.codeTF.text?.count != 6 {
            MBProgressHUD.showError(error: "请输入正确的验证码");
            return;
        }
        
        MZAPI.verifyCode(mobile: self.noneSpaseString(string: self.phoneNumTF.text), type: 1, code: self.codeTF.text, callback: { (data, rmsg) in
            if rmsg == "ok" {
                let vc = MZSetupPasswordVC.init(nibName: "MZSetupPasswordVC", bundle: nil);
                vc.mobile = self.noneSpaseString(string: self.phoneNumTF.text);
                self.navigationController?.pushViewController(vc, animated: true);
            } else {
                MBProgressHUD.showError(error: rmsg);
            }
        })
    }
    
    @objc func getCode() -> Void {
        if self.noneSpaseString(string: self.phoneNumTF.text)?.isPhoneNum() == false {
            MBProgressHUD.showError(error: "请输入正确的手机号码");
            return;
        }
        MZAPI.getCode(mobile: self.noneSpaseString(string: self.phoneNumTF.text), type: 1) { (data, rmsg) in
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
        if textField == self.phoneNumTF {
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
                if (textField.text?.count)!+string.count-range.length > 6 {
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
