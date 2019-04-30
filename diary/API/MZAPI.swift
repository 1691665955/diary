//
//  MZAPI.swift
//  diary
//
//  Created by 曾龙 on 2018/7/19.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import Alamofire

class MZAPI: NSObject {
    
    /// post请求
    ///
    /// - Parameters:
    ///   - url: 短链接
    ///   - params: 参数
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func request(url:String!,params:[String:Any]?,callback:@escaping (NSDictionary?,String)->Void) -> Void {
        let newUrl:String! = String.apiWithShortUrl(url: url);
        var parameters = params;
        parameters?.updateValue(MZAPI.getToken(), forKey: "token");
        Alamofire.request(newUrl, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseString { response in
            if (response.result.isSuccess) {
                print(newUrl);
                print(parameters as Any);
                print(response);
                let dic:NSDictionary = MZAPI.convertToDictionary(text: response.result.value!)!;
                let data:NSDictionary? = dic.value(forKey: "data") as? NSDictionary;
                let rmsg:String! = dic.value(forKey: "rmsg") as? String;
                let rcode:NSNumber! = dic.value(forKey: "rcode") as? NSNumber;
                if (rcode.intValue == 10000) {
                    callback(data,"ok");
                } else {
                    callback(nil,rmsg!);
                }
            } else {
                callback(nil,"网络错误");
            }
        }
    }
    
    
    /// json字符串转OC字典
    ///
    /// - Parameter text: json字符串
    /// - Returns: OC字典
    static func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func getToken()->String {
        let token:String? = UserDefaults.standard.value(forKey: "token") as? String;
        if token != nil {
            return token!;
        }
        return "";
    }
    
    
    /// 获取验证码
    ///
    /// - Parameters:
    ///   - moblie: 手机号号码
    ///   - type: 验证码类型（1:注册 2:登录 3:忘记密码）
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func getCode(mobile:String!,type:NSNumber!,callback:@escaping (NSDictionary?,String)->Void) -> Void {
        if mobile.isPhoneNum() == false {
            callback(nil,"手机号码错误");
            return;
        }
        SMSSDK.getVerificationCode(by: SMSGetCodeMethod.SMS, phoneNumber: mobile, zone: "86", template: nil) { (error) in
            if(error == nil) {
                let params:[String : Any] = ["mobile":mobile!,"type":type!];
                MZAPI.request(url: "/server/common/getCode", params: params) { (data, rmsg) in
                    callback(data,rmsg);
                }
            } else {
                callback(nil,"获取验证码失败");
            }
        };
    }
    
    /// 验证手机验证码
    ///
    /// - Parameters:
    ///   - mobile: 手机号码
    ///   - type: 验证码类型（1:注册 3:忘记密码）
    ///   - code: 验证码
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func verifyCode(mobile:String!,type:NSNumber!,code:String!,callback:@escaping (NSDictionary?,String)->Void) ->Void {
        if mobile.isPhoneNum() == false {
            callback(nil,"手机号码错误");
            return;
        }
        let params:[String : Any] = ["mobile":mobile!,"type":type!,"code":code!];
        MZAPI.request(url: "/server/common/verifyCode", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 注册
    ///
    /// - Parameters:
    ///   - mobile: 手机号码
    ///   - password: 密码
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func register(mobile:String!,password:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        if mobile.isPhoneNum() == false {
            callback(nil,"手机号码错误");
            return;
        }
        let params:[String : Any] = ["mobile":mobile!,"password":password!];
        MZAPI.request(url: "/server/common/register", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 账号密码登录
    ///
    /// - Parameters:
    ///   - mobile: 手机号码
    ///   - password: 密码
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func loginByPassword(mobile:String!,password:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        if mobile.isPhoneNum() == false {
            callback(nil,"手机号码错误");
            return;
        }
        let params:[String : Any] = ["mobile":mobile!,"password":password!];
        MZAPI.request(url: "/server/common/loginByPassword", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 验证码登录
    ///
    /// - Parameters:
    ///   - mobile: 手机号码
    ///   - code: 短信验证码
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func loginByCode(mobile:String!,code:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        if mobile.isPhoneNum() == false {
            callback(nil,"手机号码错误");
            return;
        }
        let params:[String : Any] = ["mobile":mobile!,"code":code!];
        MZAPI.request(url: "/server/common/loginByCode", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 忘记密码
    ///
    /// - Parameters:
    ///   - mobile: 手机号码
    ///   - password: 密码
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func forgotPassword(mobile:String!,password:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        if mobile.isPhoneNum() == false {
            callback(nil,"手机号码错误");
            return;
        }
        let params:[String : Any] = ["mobile":mobile!,"password":password!];
        MZAPI.request(url: "/server/common/forgotPassword", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 重置密码
    ///
    /// - Parameters:
    ///   - password: 新密码
    ///   - oldPassword: 旧密码
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func resetPassword(password:String!,oldPassword:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let params:[String : Any] = ["oldPassword":oldPassword!,"password":password!];
        MZAPI.request(url: "/server/common/resetPassword", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - photo: 图片
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func uploadPhoto(photo:UIImage!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let data = UIImageJPEGRepresentation(photo, 1);
        let encodeImageString:String = (data?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters))!;
        let params:[String : Any] = ["imgData":encodeImageString];
        MZAPI.request(url: "/server/upload/uploadImage", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    
    /// 添加日记
    ///
    /// - Parameters:
    ///   - content: 日记内容
    ///   - images: 日记图片
    ///   - privateStatus: 是否公开：0:不公开 1:公开
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func addDiary(content:String,images:NSArray?,privateStatus:NSInteger,callback:@escaping (NSDictionary?,String)->Void)->Void {
        var photos = String.init();
        if (images != nil) {
            for i in 0..<images!.count {
                let image:UIImage! = images![i] as? UIImage;
                let data = UIImageJPEGRepresentation(image, 1);
                let encodeImageString:String = (data?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters))!;
                photos.append(encodeImageString);
                if(i < images!.count-1) {
                    photos.append(",");
                }
            }
        }
        
        var params:[String : Any] = ["content":content,"status":privateStatus];
        if images != nil {
            params.updateValue(photos, forKey: "images");
        }
        MZAPI.request(url: "/server/diaryManage/addDiary", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 我的日记
    ///
    /// - Parameters:
    ///   - pageNum: 页码
    ///   - pageSize: 每页显示的数量
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func getMyDiary(pageNum:NSInteger,pageSize:String,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let params:[String : Any] = ["pageNum":pageNum,"pageSize":pageSize];
        MZAPI.request(url: "/server/diaryManage/getMyDiary", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 随便逛逛
    ///
    /// - Parameter callback: 回调（rmsg为ok时代表请求成功）
    static func getOtherDiary(callback:@escaping (NSDictionary?,String)->Void) ->Void {
        let params:[String : Any] = [:];
        MZAPI.request(url: "/server/diaryManage/getOtherDiary", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 浏览历史
    ///
    /// - Parameters:
    ///   - pageNum: 页码
    ///   - pageSize: 每页显示的数量
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func getHistoryDiary(pageNum:NSInteger,pageSize:String,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let params:[String : Any] = ["pageNum":pageNum,"pageSize":pageSize];
        MZAPI.request(url: "/server/diaryManage/getHistoryDiary", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 我的点赞
    ///
    /// - Parameters:
    ///   - pageNum: 页码
    ///   - pageSize: 每页显示的数量
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func getStarDiary(pageNum:NSInteger,pageSize:String,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let params:[String : Any] = ["pageNum":pageNum,"pageSize":pageSize];
        MZAPI.request(url: "/server/diaryManage/getStarDiary", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 点赞
    ///
    /// - Parameters:
    ///   - diaryID: 日记ID
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func star(diaryID:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let params:[String : Any] = ["diaryID":diaryID!];
        MZAPI.request(url: "/server/diaryManage/star", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 取消点赞
    ///
    /// - Parameters:
    ///   - diaryID: 日记ID
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func cancelStar(diaryID:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let params:[String : Any] = ["diaryID":diaryID!];
        MZAPI.request(url: "/server/diaryManage/cancelStar", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 获取评论列表
    ///
    /// - Parameters:
    ///   - pageNum: 页码
    ///   - pageSize: 每页显示的数量
    ///   - diaryID: 日记ID
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func getCommentList(pageNum:NSInteger,pageSize:String,diaryID:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        let params:[String : Any] = ["pageNum":pageNum,"pageSize":pageSize,"diaryID":diaryID!];
        MZAPI.request(url: "/server/diaryManage/getCommentList", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 评论日记或评论
    ///
    /// - Parameters:
    ///   - diaryID: 日记ID
    ///   - content: 评论内容
    ///   - commentID: 评论ID
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func commentDiary(diaryID:String!,content:String!,commentID:String!,callback:@escaping (NSDictionary?,String)->Void)->Void {
        var params:[String : Any] = ["diaryID":diaryID!,"content":content!];
        if commentID != nil {
            params["commentID"] = commentID;
        }
        MZAPI.request(url: "/server/diaryManage/commentDiary", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 个人中心
    ///
    /// - Parameter callback: 回调（rmsg为ok时代表请求成功）
    static func personCenter(callback:@escaping (NSDictionary?,String)->Void) -> Void {
        let params:[String : Any] = [:];
        MZAPI.request(url: "/server/person/personCenter", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 更新头像
    ///
    /// - Parameters:
    ///   - avatar: 头像
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func updateAvatar(avatar:UIImage!,callback:@escaping (NSDictionary?,String)->Void) ->Void {
        let data = UIImageJPEGRepresentation(avatar, 1);
        let encodeImageString:String = (data?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters))!;
        let params:[String : Any] = ["avatar": encodeImageString];
        MZAPI.request(url: "/server/person/updateAvatar", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 更新用户名
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func updateUsername(username:String!,callback:@escaping (NSDictionary?,String)->Void) ->Void {
        let params:[String : Any] = ["username": username!];
        MZAPI.request(url: "/server/person/updateUsername", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
    
    /// 更新性别
    ///
    /// - Parameters:
    ///   - sex: 性别
    ///   - callback: 回调（rmsg为ok时代表请求成功）
    static func updateSex(sex:String!,callback:@escaping (NSDictionary?,String)->Void) ->Void {
        let params:[String : Any] = ["sex": sex!];
        MZAPI.request(url: "/server/person/updateSex", params: params) { (data, rmsg) in
            callback(data,rmsg);
        }
    }
}
