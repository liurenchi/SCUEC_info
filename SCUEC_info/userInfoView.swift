//
//  userInfoView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import Alamofire
class userInfoView: UIViewController
{

    @IBOutlet weak var outputView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(Router.GetUserInfo).responseString (encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
                   // println(string)
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
//            println(city)
//             println("------raw----")
//             println(city.raw)
//            println("-----content-----")
//            println(city.content)
//             println("-----tagname-----")
//            println(city.tagName)
//             println("-----attributes-----")
//             println(city.attributes)
//            println("------children----")
//            println(city.children)
//             println("-----firstchild-----")
//             println(city.firstChild)
//             println("----parent----")
//             println(city.parent)
            
            self.outputView.text = output.content
            
            }else{
                println("nil")
            }
 
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

  
}
