//
//  libraryRouter.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/20.
//  Copyright (c) 2015年  Lrcray. All rights reserved.

/*———————————————————————————————————————
Alamofire请求的路由，里面定义了不同的请求方式
———————————————————————————————————————*/
import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    //用户验证
    static let libraryURLString = "http://coin.lib.scuec.edu.cn/reader/redr_verify.php"
    //用户信息
    static let userInfoURLString = "http://coin.lib.scuec.edu.cn/reader/redr_info.php"
    //当前借阅
    static let currentBookURLString = "http://coin.lib.scuec.edu.cn/reader/book_lst.php"
    //续借请求地址
    static let renewBookURLString = "http://coin.lib.scuec.edu.cn/reader/ajax_renew.php"
    //借阅历史
    static let bookHistoryURLString = "http://coin.lib.scuec.edu.cn/reader/book_hist.php"
    
    static var OAuthToken: String?
    //请求模式
    case LoginUser([String: AnyObject])
    case GetUserInfo
    case GetCurrentBook
    case RenewBook([String: AnyObject])
    case GetBookHistory
    
    //请求的方法
    var method: Alamofire.Method {
        switch self {
        case .LoginUser:
            return .POST
        case .GetCurrentBook, .GetUserInfo, .GetBookHistory, .RenewBook:
            return .GET

        }
    }
    
    var URLPATH: String {
        switch self {
        case .LoginUser:
            return Router.libraryURLString
        case .GetUserInfo:
            return Router.userInfoURLString
        case .GetCurrentBook:
            return Router.currentBookURLString
        case .RenewBook:
            return Router.renewBookURLString
        case .GetBookHistory:
            return Router.bookHistoryURLString
        }
    }
    
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        
        let URL = NSURL(string: URLPATH)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let cookie_name = defaults.stringForKey("Cookie_name"){
            if let cookie_value = defaults.stringForKey("Cookie_value"){
                mutableURLRequest.setValue("\(cookie_name)=\(cookie_value)", forHTTPHeaderField: "Cookie")
                println("router:\(cookie_value)")
            }}
        
        switch self {
        case .LoginUser(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case  .RenewBook(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
