//
//  MZCommentModel.swift
//  diary
//
//  Created by 曾龙 on 2019/3/7.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import HandyJSON

class MZCommentModel: HandyJSON {
    var commentID: String?
    var content: String?
    var commentTime: String?
    var userID: String?
    var username: String?
    var avatar: String?
    var replyID: String?
    var replyName: String?
    var replyAvatar: String?
    var diaryID: String?
    var subCommentList: [MZCommentModel]?
    
    required init(){};
}
