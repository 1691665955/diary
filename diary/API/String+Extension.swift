//
//  String+Extension.swift
//  diary
//
//  Created by 曾龙 on 2018/7/19.
//  Copyright © 2018年 mz. All rights reserved.
//

import Foundation

extension String {
    static func apiWithShortUrl(url:String!) -> String! {
        return "http://192.168.50.126" + url;
    }
    
    func isPhoneNum() -> Bool {
        let phone = "1[3|4|5|6|7|8|9|][0-9]{9}"
        let phoneText = NSPredicate.init(format: "SELF MATCHES%@", phone);
        return phoneText.evaluate(with:self);
    }
    
    func md5() ->String!{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
//        result.deinitialize()
        return String(format: hash as String)
    }
    
    func getFormatterTimeString() -> String {
        let dateNow = Date();
        let timeNow = dateNow.timeIntervalSince1970;
        if (timeNow - Double(self)! < 60) {
            return "刚刚";
        } else if (timeNow - Double(self)! < 60*60) {
            return String.init(format:"%ld",Int(timeNow - Double(self)!)/60) + "分钟前";
        } else if (timeNow - Double(self)! < 60*60*12) {
            return String.init(format:"%ld",Int(timeNow - Double(self)!)/3600) + "小时前";
        } else {
            let formatter = DateFormatter();
            formatter.dateFormat = "YYYY-MM-dd HH:mm";
            let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
            formatter.timeZone = timeZone
            
            var formatterTime = formatter.string(from: Date.init(timeIntervalSince1970: Double(self)!)) as NSString;
            let interval1 = Int(timeNow) - Int(timeNow)%(3600*24);
            let interval2 = Int(self)! - Int(self)!%(3600*24);
            if (interval1 == interval2) {
                formatterTime = formatterTime.replacingCharacters(in: NSMakeRange(0, 10), with: "今天") as NSString;
            } else if (interval1 - interval2 == 3600*24) {
                formatterTime = formatterTime.replacingCharacters(in: NSMakeRange(0, 10), with: "昨天") as NSString;
            } else {
                let nowFormatterTime = formatter.string(from: Date()) as NSString;
                if (formatterTime.substring(to: 4) == nowFormatterTime.substring(to: 4)) {
                    formatterTime = formatterTime.substring(from: 5) as NSString;
                }
            }
            return formatterTime as String;
        }
    }
}
