//
//  douRouter.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/1.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import Foundation
import Alamofire

enum doubanRouter: URLRequestConvertible {

//-----豆瓣api
    static let searchBookApi = "https://api.douban.com/v2/book/search"
    
    
    static var OAuthToken: String?
    //请求模式
    case searchBook([String: AnyObject])

    
    
    //请求的方法
    var method: Alamofire.Method {
        switch self {

        case .searchBook:
            return .GET
        default:
            return .GET
        }
    }
    
    var URLPATH: String {
        switch self {
        case .searchBook:
            return doubanRouter.searchBookApi
        }
    }
    
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        
        let URL = NSURL(string: URLPATH)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        switch self {
        case .searchBook(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
