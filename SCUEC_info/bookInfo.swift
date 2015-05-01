//
//  bookInfo.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/1.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class bookInfo: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TableView: UITableView!
    var bookname: String!
    var favbook: [Favorites]!
    var bookdetail :NSMutableDictionary = ["":""]
    var itemname:NSArray = ["书名:","作者:","译者:","出版社:","出版年:","页数:","定价:","装帧: ","ISBN: ","作者简介:","内容简介:"]
    var enitemname:NSArray = ["title","author","translator","publisher","pubdate","pages","price","binding","isbn13","author_intro","summary"]
    
    override func viewDidLoad() {
    super.viewDidLoad()
    //self sizing cell
    TableView.estimatedRowHeight = 40
    TableView.rowHeight = UITableViewAutomaticDimension
    //coredata
    favbook = fetchCoreData("favor_FetchRequest") as! [Favorites]
    
    Alamofire.request(doubanRouter.searchBook(["q":"\(bookname)"])).responseJSON { (_, _, json, _)  in
        var jsondata = JSON(json!)
      
        //解析json 获取基本书籍信息
        for (key: String, subJson: JSON) in jsondata["books"][0] {
          //  println(key)
            var keyvalue = key
            for item in self.enitemname{
                if keyvalue == item as! String{
                    if var data = jsondata["books"][0]["\(keyvalue)"].string{
                        self.bookdetail.setObject(data, forKey: keyvalue)}
                    else {
                        var data = jsondata["books"][0]["\(keyvalue)"][0].stringValue
                        self.bookdetail.setObject(data, forKey: keyvalue)
                    }
                }
            }
        }
        //解析json 获取图片地址
        var bookimgURL: NSMutableArray = []

        if var data = jsondata["books"][0]["images"]["large"].string{
            bookimgURL.addObject(data)
        }
        if var data = jsondata["books"][0]["images"]["medium"].string{
            bookimgURL.addObject(data)
        }

        
        
        //刷新数据
        self.TableView.reloadData()
        
        
        }
        
       
        
      
        
    }
//    override func viewDidAppear(animated: Bool) {
//        // self sizing cell 的bug
//        TableView.reloadData()
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return enitemname.count    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! bookdetailCell
        //配置cell
        var key = enitemname[indexPath.row] as! String
        cell.detail.text = bookdetail.valueForKey(key) as? String
        cell.item.text = itemname[indexPath.row] as? String
        
        
        return cell
    
    }

}
