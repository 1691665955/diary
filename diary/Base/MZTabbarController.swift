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
        tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:RGB(r: 108, g: 108, b: 108)], for: UIControlState.normal);
        tabbarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:RGB(r: 0, g: 212, b: 71)], for: UIControlState.selected);
    }

    func setupController(vc:UIViewController,title:String,image:UIImage,selectedImage:UIImage) -> Void {
        let item = UITabBarItem.init(title:title, image: image.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal));
        vc.tabBarItem = item;
        let nvc = MZNavigationController.init(rootViewController: vc);
        self.addChildViewController(nvc);
    }
    
    func setupChildViewControllers() -> Void {
        let mainPageVC = MZMainPageVC.init(nibName: "MZMainPageVC", bundle: nil);
        self.setupController(vc: mainPageVC, title: "日记", image: UIImage.init(named: "diary_normal")!, selectedImage: UIImage.init(named: "diary_selected")!);
        let personCenterVC = MZPersonCenterVC.init(nibName: "MZPersonCenterVC", bundle: nil);
        self.setupController(vc: personCenterVC, title: "我的", image: UIImage.init(named: "person_normal")!, selectedImage: UIImage.init(named: "person_selected")!);
    }
}
