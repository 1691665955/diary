//
//  MZLeadingVC.swift
//  diary
//
//  Created by 曾龙 on 2018/6/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit

import SDWebImage

class MZLeadingVC: MZFatherController,UIScrollViewDelegate {
    
    var indexView1:UIView!
    var indexView2:UIView!
    var indexView3:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.image = UIImage.createImage(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), startColor: RGB(r: 0, g: 212, b: 71), endColor: RGB(r: 0, g: 234, b: 89), startPoint: CGPoint.init(x: 0, y: 0), endPoint: CGPoint.init(x: 1, y: 0));
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 60, y: 40, width: SCREEN_WIDTH-120, height: (SCREEN_WIDTH-120)/2205*4000))
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = 6
        scrollView.layer.masksToBounds = true
        scrollView.delegate = self
        let imageNames = ["timelineBlue2.jpg","diaryDetailPink2.jpg","passerbyBalck2.jpg"]
        
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            let frame = scrollView.bounds
            let imageView = UIImageView.init(frame: CGRect.init(x: frame.width*CGFloat(i), y: 0, width: frame.size.width, height: frame.size.height))
            imageView.image = UIImage.init(named: imageName)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize.init(width: (SCREEN_WIDTH-120)*CGFloat(imageNames.count)
            , height: (SCREEN_WIDTH-120)/2205*4000)
        self.view.addSubview(scrollView);
        
        self.indexView1 = UIView.init(frame: CGRect.init(x: SCREEN_WIDTH/2-18, y: scrollView.frame.maxY+10, width: 10, height: 3));
        self.indexView1.backgroundColor = RGB(r: 90, g: 160, b: 245);
        self.view.addSubview(self.indexView1);
        
        self.indexView2 = UIView.init(frame: CGRect.init(x: SCREEN_WIDTH/2-5, y: scrollView.frame.maxY+10, width: 10, height: 3));
        self.indexView2.backgroundColor = UIColor.white;
        self.view.addSubview(self.indexView2);
        
        self.indexView3 = UIView.init(frame: CGRect.init(x: SCREEN_WIDTH/2+8, y: scrollView.frame.maxY+10, width: 10, height: 3));
        self.indexView3.backgroundColor = UIColor.white;
        self.view.addSubview(self.indexView3);
        
        let appNameLB = UILabel.init(frame: CGRect.init(x: 0, y: self.indexView1.frame.maxY+10, width: SCREEN_WIDTH, height: 30))
        appNameLB.text = "吾记";
        appNameLB.textColor = UIColor.white;
        if #available(iOS 8.2, *) {
            appNameLB.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium);
        } else {
            appNameLB.font = UIFont.systemFont(ofSize: 24);
        };
        appNameLB.textAlignment = NSTextAlignment.center;
        self.view.addSubview(appNameLB);
        
        let tipLB = UILabel.init(frame: CGRect.init(x: 0, y: appNameLB.frame.maxY+10, width: SCREEN_WIDTH, height: 20));
        tipLB.text = "简单精致  记录生活";
        tipLB.textColor = UIColor.white;
        tipLB.font = UIFont.systemFont(ofSize: 14);
        tipLB.textAlignment = NSTextAlignment.center;
        self.view.addSubview(tipLB);
        
        let registerBtn = UIButton.init(type: UIButtonType.custom);
        registerBtn.frame = CGRect.init(x: (SCREEN_WIDTH-120)/2, y: tipLB.frame.maxY+10, width: 120, height: 30);
        registerBtn.setTitle("立即使用", for: UIControlState.normal);
        registerBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        registerBtn.addTarget(self, action: #selector(registerAccount), for: UIControlEvents.touchUpInside);
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16);
        registerBtn.layer.cornerRadius = 4;
        registerBtn.layer.masksToBounds = true;
        registerBtn.layer.borderWidth = 1;
        registerBtn.layer.borderColor = UIColor.white.cgColor;
        self.view.addSubview(registerBtn);
        
        let loginBtn = UIButton.init(type: UIButtonType.custom);
        loginBtn.frame = CGRect.init(x: (SCREEN_WIDTH-120)/2, y: registerBtn.frame.maxY+10, width: 120, height: 20);
        loginBtn.setTitle("已有账号？登录", for: UIControlState.normal);
        loginBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        loginBtn.addTarget(self, action: #selector(loginAccount), for: UIControlEvents.touchUpInside);
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        self.view.addSubview(loginBtn);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    @objc func registerAccount() {
        let registerVC = MZRegisterVC();
        self.navigationController?.pushViewController(registerVC, animated: true);
    }
    
    @objc func loginAccount() {
        let loginVC = MZLoginVC();
        self.navigationController?.pushViewController(loginVC, animated: true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.size.width
        if page == 0 {
            self.indexView1.backgroundColor = RGB(r: 90, g: 160, b: 245)
            self.indexView2.backgroundColor = UIColor.white
            self.indexView3.backgroundColor = UIColor.white
        } else if page == 1 {
            self.indexView2.backgroundColor = RGB(r: 90, g: 160, b: 245)
            self.indexView1.backgroundColor = UIColor.white
            self.indexView3.backgroundColor = UIColor.white
        } else if page == 2 {
            self.indexView3.backgroundColor = RGB(r: 90, g: 160, b: 245)
            self.indexView1.backgroundColor = UIColor.white
            self.indexView2.backgroundColor = UIColor.white
        }
    }
}
