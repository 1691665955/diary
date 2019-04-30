//
//  MZAddDiaryVC.swift
//  diary
//
//  Created by 曾龙 on 2018/9/21.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import IQKeyboardManager
import MBProgressHUD
import MobileCoreServices

class MZAddDiaryVC: MZFatherController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageBGView: UIView!
    @IBOutlet weak var saveBottom: NSLayoutConstraint!
    //    typealias fucBlock = () -> Void
    //    var addSuccess: fucBlock!
    var addSuccess: (() -> Void)!
    var editImageView: UIImageView!
    var openBtn: UIButton!
    lazy var images:NSMutableArray = {
        let images = NSMutableArray();
        return images;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "增加日记";
        self.saveBottom.constant = Safe_Bottom+20;
        self.textView.layoutManager.allowsNonContiguousLayout = false;
        
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 75, height: 44));
        rightView.backgroundColor = UIColor.clear;
        rightView.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(openSwitchChanged));
        rightView.addGestureRecognizer(tap);
        
        let rightLB = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44));
        rightLB.textColor = UIColor.white;
        rightLB.font = UIFont.systemFont(ofSize: 16);
        rightLB.text = "公开:";
        rightView.addSubview(rightLB);
        
        let openBtn = UIButton.init(type: UIButtonType.custom);
        openBtn.frame = CGRect.init(x: 40, y: 11, width: 36.5, height: 22);
        openBtn.layer.cornerRadius = 11;
        openBtn.layer.masksToBounds = true;
        openBtn.backgroundColor = UIColor.white;
        openBtn.setBackgroundImage(UIImage.init(named: "开关关"), for: UIControlState.normal);
        openBtn.setBackgroundImage(UIImage.init(named: "开关开"), for: UIControlState.selected);
        openBtn.isSelected = true;
        openBtn.isUserInteractionEnabled = false;
        rightView.addSubview(openBtn);
        self.openBtn = openBtn;
        
        let rightItem = UIBarButtonItem.init(customView: rightView);
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    @objc func openSwitchChanged() {
        self.openBtn.isSelected = !self.openBtn.isSelected;
    }
    
    @IBAction func saveDiary(_ sender: Any) {
        if self.textView.text.count == 0 && self.images.count == 0{
            MBProgressHUD.showError(error: "请还未添加任何日记内容");
            return;
        }
        
        MZAPI.addDiary(content: self.textView.text, images: self.images, privateStatus: (self.openBtn.isSelected ? 1 : 0)) { (data, rmsg) in
            if rmsg == "ok" {
                MBProgressHUD.showSuccess(success: "保存成功");
                if ((self.addSuccess) != nil) {
                    self.addSuccess();
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //选中图片
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        self.editImageView = (sender.view as! UIImageView);
        
        let title = NSAttributedString.init(string: "请选择图片", attributes: [NSAttributedStringKey.foregroundColor:RGB(r: 153, g: 153, b: 153)]);
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
    
    //删除图片
    @IBAction func deleteImage(_ sender: UITapGestureRecognizer) {
        self.images.removeObject(at: (sender.view?.tag)!-20);
        self.loadImages();
    }
    
    //MARK:-UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editImage = info[UIImagePickerControllerEditedImage] as! UIImage;
        if self.images.count > self.editImageView.tag-10 {
            self.images.replaceObject(at: self.editImageView.tag-10, with: editImage);
        } else {
            self.images.add(editImage);
        }
        self.loadImages();
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
    
    @objc func loadImages() -> Void {
        for i in 0 ..< 4 {
            if (i < self.images.count) {
                let imageView = self.imageBGView.viewWithTag(10+i) as! UIImageView;
                imageView.image = self.images[i] as? UIImage;
                imageView.isHidden = false;
                let deleteView = self.imageBGView.viewWithTag(20+i);
                deleteView?.isHidden = false;
            } else {
                let imageView = self.imageBGView.viewWithTag(10+i) as! UIImageView;
                imageView.image = UIImage.init(named: "selectImage");
                imageView.isHidden = true;
                let deleteView = self.imageBGView.viewWithTag(20+i);
                deleteView?.isHidden = true;
            }
        }
        if self.images.count < 4 {
            let imageView = self.imageBGView.viewWithTag(10+self.images.count) as! UIImageView;
            imageView.isHidden = false;
        }
    }
    
    //MARK:-UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize.init(width: SCREEN_WIDTH-32, height: CGFloat.greatestFiniteMagnitude));
        if size.height > 100 {
            let height = SCREEN_HEIGHT - Navi_Height - Safe_Bottom - 128 - (SCREEN_WIDTH - 100.0)/4.0;
            if size.height > height {
                self.textViewHeight.constant = height;
            } else {
                self.textViewHeight.constant = size.height;
            }
        } else {
            self.textViewHeight.constant = 100;
        }
        textView.layoutIfNeeded();
        IQKeyboardManager.shared().reloadLayoutIfNeeded();
    }
}
