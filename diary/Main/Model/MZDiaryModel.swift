//
//  MZDiaryModel.swift
//  diary
//
//  Created by 曾龙 on 2018/8/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import HandyJSON

class MZDiaryModel: HandyJSON {
    var diaryID:String?
    var userID:String?
    var username: String?
    var avatar: String?
    var content:String?
    var images:NSArray?
    var time:String?
    var star:String?
    var read:String?
    var status:String?
    var type: String?
    var hasRead: String?
    var hasStar: String?
    var commentCount: String?
    
    required init(){};
}
