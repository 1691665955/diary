//
//  MZDataUtil.swift
//  diary
//
//  Created by 曾龙 on 2019/2/28.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit

class MZDataUtil: NSObject {
    public static func saveOtherDiary(diaryList:[NSDictionary]) {
        let userDefaults = UserDefaults.standard;
        var key = "otherDiary";
        key.append(userDefaults.value(forKey: "token") as! String);
        var originDiaryList = userDefaults.value(forKey: key) as? [NSDictionary];
        if originDiaryList == nil {
            originDiaryList = [] as? [NSDictionary];
        }
        originDiaryList = diaryList + originDiaryList!;
        userDefaults.set(originDiaryList, forKey: key);
        userDefaults.synchronize();
    }
    
    public static func resetOtherDiary(diaryList:[NSDictionary]) {
        let userDefaults = UserDefaults.standard;
        var key = "otherDiary";
        key.append(userDefaults.value(forKey: "token") as! String);
        userDefaults.set(diaryList, forKey: key);
        userDefaults.synchronize();
    }
    
    public static func getOtherDiary()->[NSDictionary] {
        let userDefaults = UserDefaults.standard;
        var key = "otherDiary";
        key.append(userDefaults.value(forKey: "token") as! String);
        var originDiaryList = userDefaults.value(forKey: key);
        if originDiaryList == nil {
            originDiaryList = [];
        }
        return originDiaryList! as! [NSDictionary];
    }
}
