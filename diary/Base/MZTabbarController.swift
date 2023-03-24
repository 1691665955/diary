//
//  MZTabbarController.swift
//  diary
//
//  Created by 曾龙 on 2019/3/1.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit

class MZTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupChildViewControllers();
        
        let tabbarItem = UITabBarItem.appearance();
        tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:MZThemeManage.TabbarNormalColor()], for: UIControlState.normal);
        tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:MZThemeManage.MainColor()], for: UIControlState.selected);
    }

    func setupController(vc:UIViewController,title:String,image:UIImage,selectedImage:UIImage) -> Void {
        let item = UITabBarItem.init(title:title, image: image.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal));
        vc.tabBarItem = item;
        let nvc = MZNavigationController.init(rootViewController: vc);
        self.addChildViewController(nvc);
    }
    
    func setupChildViewControllers() -> Void {
        let mainPageVC = MZMainPageVC.init(nibName: "MZMainPageVC", bundle: nil);
        self.setupController(vc: mainPageVC, title: "日记", image: MZThemeManage.imageNamed(name: "diary_normal"), selectedImage: MZThemeManage.imageNamed(name: "diary_selected"));
        let squareCenterVC = MZSquareCenterVC.init(nibName: "MZSquareCenterVC", bundle: nil);
        self.setupController(vc: squareCenterVC, title: "广场", image: MZThemeManage.imageNamed(name: "square_normal"), selectedImage: MZThemeManage.imageNamed(name: "square_selected"));
        let personCenterVC = MZPersonCenterVC.init(nibName: "MZPersonCenterVC", bundle: nil);
        self.setupController(vc: personCenterVC, title: "我的", image: MZThemeManage.imageNamed(name: "person_normal"), selectedImage: MZThemeManage.imageNamed(name: "person_selected"));
    }
}
