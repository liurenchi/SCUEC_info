//
//  currentBookView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import Alamofire
class currentBookView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(Router.GetCurrentBook).responseString (encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
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
        if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='mylib_content']/table") {
           
            //字符串筛选
            var string = output.content.stringByReplacingOccurrencesOfString("\t", withString: "")
            var string1 = string.stringByReplacingOccurrencesOfString("\n", withString: "")
            var string2 = string1.stringByReplacingOccurrencesOfString("\r", withString: "|")
            //字符串存入数组并转化为可变
            var nsArray: NSArray = string2.componentsSeparatedByString("|")
            var strArray = nsArray.mutableCopy() as! NSMutableArray
            //有用数据开始的元素索引
            var usefulindex: Int!
            //找到有用数据的下标
            for array in strArray{
                
                if isPureNumandCharacters(array as! String){
                    usefulindex = strArray.indexOfObject(array)
                    //println(usefulindex)
                    break
                }
                
            }
            //删除无用数据
            var loop = usefulindex - 1
            for (var i = loop ; i >= 0; i--){
                strArray.removeObjectAtIndex(i)
            }
           // for array in strArray{println(array)}
            
        }else{
            println("nil")
        }
        
    }
       /*Dividing Strings
    componentsSeparatedByString(_:)
    componentsSeparatedByCharactersInSet(_:)
    stringByTrimmingCharactersInSet(_:)
    */

    
}
