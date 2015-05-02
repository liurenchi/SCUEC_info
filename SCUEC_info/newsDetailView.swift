
//
//  newsDetailView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/2.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import Alamofire
class newsDetailView: UITableViewController
{

    var newsurl:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        var range = NSRange(location: 0, length: 1)
//        var requestUrl = self.newsurl.stringByReplacingCharactersInRange(range, withString: "http://news.scuec.edu.cn/xww")
        var requestUrl = newsurl.stringByReplacingOccurrencesOfString("./", withString: "http://news.scuec.edu.cn/xww/")
       
        Alamofire.request(.GET, "\(requestUrl)").response { (_, _, data, error) in
            
            if error != nil {
                println("新闻详情请求错误")
            }else{
                if data != nil {
                    var parsedata = data as! NSData
                    self.parseNewsDetail(parsedata)
                    
                    
                }}
        }

    
    }

    
    //MARK:- TFHpple解析方法
    func parseNewsDetail(data:NSData){
        
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin newstableparse!")
        var loop:Int = 1
        
            if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='container']/section/article/div[3]") {
                
               println(output.content)
                
            }else{
                println("获取新闻列表数据出错")}
        
        self.tableView.reloadData()
    }
    
    
    
    
    
    // MARK: - Table view data source

   
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 1
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

         Configure the cell...

        return cell
    }
    */

   }
