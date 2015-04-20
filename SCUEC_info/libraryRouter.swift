//
//  libraryRouter.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/20.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    //用户验证
    static let libraryURLString = "http://coin.lib.scuec.edu.cn/reader/redr_verify.php"
    //当前借阅
    static let readerBookURLString = "http://coin.lib.scuec.edu.cn/reader/book_lst.php"
    //借阅历史
    static let bookHistoryURLString = "http://coin.lib.scuec.edu.cn/reader/book_hist.php"
    
    static var OAuthToken: String?
    
    case LoginUser([String: AnyObject])
    case GetBookInfo
    case GetBookHistory
    case DestroyUser(String)
    
    var method: Alamofire.Method {
        switch self {
        case .LoginUser:
            return .POST
        case .GetBookInfo:
            return .GET
        case .GetBookHistory:
            return .GET
        case .DestroyUser:
            return .DELETE
        }
    }
    
    var URLPATH: String {
        switch self {
        case .LoginUser:
            return Router.libraryURLString
        case .GetBookInfo:
            return Router.readerBookURLString
        case .GetBookHistory:
            return Router.bookHistoryURLString
        case .DestroyUser(let username):
            return "/users/\(username)"
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
                println(cookie_value)
            }}
        
        switch self {
        case .LoginUser(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
