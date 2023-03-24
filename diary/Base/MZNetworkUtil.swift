//
//  MZNetworkUtil.swift
//  diary
//
//  Created by 曾龙 on 2019/11/20.
//  Copyright © 2019 mz. All rights reserved.
//

import UIKit
import Alamofire

class MZNetworkUtil: NSObject {
    class func getNetworkEnable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
