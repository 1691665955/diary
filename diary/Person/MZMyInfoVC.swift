//
//  MZMyInfoVC.swift
//  diary
//
//  Created by 曾龙 on 2019/3/1.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MobileCoreServices
import MBProgressHUD

class MZMyInfoVC: MZFatherController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var userModel: MZUser!
    var avatar: UIImage!
    var updateAvaterSuccess:((_ avatar:UIImage?) -> Void)!
    var updateUsernameSuccess:((_ username:String?) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的资料";
        self.tableView.register(UINib.init(nibName: "MZMyInfoCell", bundle: nil), forCellReuseIdentifier: "MZMyInfoCell")
    }

    //MARK:-UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MZMyInfoCell") as! MZMyInfoCell;
        cell.type = MZMyInfoCellType(rawValue: indexPath.row);
        cell.model = self.userModel;
        if self.avatar != nil {
            cell.avatar = self.avatar;
        }
        return cell;
    }
    
    //MARK:-UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.updateAvatar();
        } else if indexPath.row == 1 {
            self.updateNickname();
        } else {
            self.updateSex();
        }
    }
    
    func updateAvatar() -> Void {
        let title = NSAttributedString.init(string: "修改头像", attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 153, g: 153, b: 153)]);
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet);
        actionSheet.setValue(title, forKey: "attributedTitle");
        let photoAction = UIAlertAction.init(title: "相册", style: UIAlertActionStyle.default) { (action) in
            let imagePicker = UIImagePickerController.init();
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.mediaTypes = [kUTTypeImage as String];
            imagePicker.allowsEditing = true;
            self.present(imagePicker, animated: true, completion: nil);
        };
        photoAction.setValue(RGB(r: 0, g: 212, b: 71), forKey: "titleTextColor");
        actionSheet.addAction(photoAction);
        let cameraAction = UIAlertAction.init(title: "相机", style: UIAlertActionStyle.default) { (action) in
            let imagePicker = UIImagePickerController.init();
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.mediaTypes = [kUTTypeImage as String];
            imagePicker.allowsEditing = true;
            self.present(imagePicker, animated: true, completion: nil);
        };
        cameraAction.setValue(RGB(r: 0, g: 212, b: 71), forKey: "titleTextColor");
        actionSheet.addAction(cameraAction);
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        };
        cancelAction.setValue(RGB(r: 136, g: 136, b: 136), forKey: "titleTextColor");
        actionSheet.addAction(cancelAction);
        self.present(actionSheet, animated: true, completion: nil);
    }
    
    func updateNickname() -> Void {
        let editUsernameVC = MZEidtUsernameVC.init(nibName: "MZEidtUsernameVC", bundle: nil);
        editUsernameVC.updateUsernameSuccess = { username in
            self.userModel.username = username;
            self.tableView.reloadData();
            if (self.updateUsernameSuccess != nil) {
                self.updateUsernameSuccess(username);
            }
        }
        self.navigationController?.pushViewController(editUsernameVC, animated: true);
    }
    
    func updateSex() -> Void {
        let title = NSAttributedString.init(string: "选择性别", attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 153, g: 153, b: 153)]);
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet);
        actionSheet.setValue(title, forKey: "attributedTitle");
        let maleAction = UIAlertAction.init(title: "男", style: UIAlertActionStyle.default) { (action) in
            MZAPI.updateSex(sex: "1", callback: { (data, rmsg) in
                if rmsg == "ok" {
                    self.userModel.sex = "1";
                    self.tableView.reloadData();
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            })
        };
        maleAction.setValue(RGB(r: 0, g: 212, b: 71), forKey: "titleTextColor");
        actionSheet.addAction(maleAction);
        let femaleAction = UIAlertAction.init(title: "女", style: UIAlertActionStyle.default) { (action) in
            MZAPI.updateSex(sex: "2", callback: { (data, rmsg) in
                if rmsg == "ok" {
                    self.userModel.sex = "2";
                    self.tableView.reloadData();
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            })
        };
        femaleAction.setValue(RGB(r: 0, g: 212, b: 71), forKey: "titleTextColor");
        actionSheet.addAction(femaleAction);
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        };
        cancelAction.setValue(RGB(r: 136, g: 136, b: 136), forKey: "titleTextColor");
        actionSheet.addAction(cancelAction);
        self.present(actionSheet, animated: true, completion: nil);
    }

    
    //MARK:-UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editImage = info[UIImagePickerControllerEditedImage] as! UIImage;
        MZAPI.updateAvatar(avatar: editImage) { (data, rmsg) in
            if rmsg == "ok" {
                self.avatar = editImage;
                if self.updateAvaterSuccess != nil {
                    self.updateAvaterSuccess(editImage);
                }
                self.tableView.reloadData();
            } else {
                MBProgressHUD.showError(error: rmsg);
            }
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
}
