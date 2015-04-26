//
//  userInfoView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
用户基本信息的请求，当前的借阅情况的简单返回
———————————————————————————————————————*/
import UIKit
import Alamofire
class userInfoView: UIViewController
{

    @IBOutlet weak var outputView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(Router.GetUserInfo).responseString (encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
             //测试      // println(string)
            }).response({ (_, _, data, _) in
            if data != nil {
                var parsedata = data as! NSData
                 self.parseData(parsedata)
               }
            })

    }

  
    func parseData(data:NSData){
        
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin parse!")
        if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='mylib_content']/div[1]") {
            self.outputView.text = output.content
            }else{
                println("nil")
            }
 
    }

}
