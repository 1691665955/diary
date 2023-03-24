//
//  AppDelegate.swift
//  diary
//
//  Created by 曾龙 on 2018/6/19.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible();
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true;
        IQKeyboardManager.shared().isEnableAutoToolbar = false;
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 0;
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true);
        
        let userDefault = UserDefaults.standard;
        let token = userDefault.string(forKey: "token");
        if (token != nil) {
            let vc = MZTabbarController();
            self.window?.rootViewController = vc;
        } else {
            let leadingVC = MZLeadingVC();
            let nvc = MZNavigationController.init(rootViewController: leadingVC);
            self.window?.rootViewController = nvc;
        }
        
        return true
    }

}

