//
//  MZUser.swift
//  diary
//
//  Created by 曾龙 on 2019/3/1.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import HandyJSON

class MZUser: HandyJSON {
    var userID: String!
    var username: String!
    var sex: String?
    var avatar: String?
    var mobile: String!
    
    required init(){};
}
