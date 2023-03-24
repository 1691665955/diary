//
//  MZThemeManage.swift
//  diary
//
//  Created by 曾龙 on 2019/11/14.
//  Copyright © 2019 mz. All rights reserved.
//

import UIKit

enum Theme:String {
    case Default = "Default"
}

class MZThemeManage: NSObject {
    static func changeTheme(theme:Theme) -> Void {
        let userDefaults = UserDefaults.standard;
        userDefaults.set(theme, forKey: "Theme");
        userDefaults.synchronize();
        NotificationCenter.default.post(name: MZNoticitionNameThemeChanged, object: nil);
    }
    
    static func getTheme() -> Theme {
        let theme = UserDefaults.standard.value(forKey: "Theme");
        if theme != nil {
            return theme as! Theme;
        }
        return Theme.Default;
    }
    
    static func imageNamed(name:String!) -> UIImage {
        return UIImage.init(named: (getTheme() == Theme.Default ? name : getTheme().rawValue+name) ?? name)!;
    }
    
    static func MainColor() -> UIColor {
        switch getTheme() {
        case Theme.Default:
            return RGB(r: 64, g: 228, b: 176);
        }
    }
    
    static func TabbarNormalColor() -> UIColor {
        switch getTheme() {
        case Theme.Default:
            return RGB(r: 108,g: 108,b: 108);
        }
    }
}
