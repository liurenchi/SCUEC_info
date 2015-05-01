//
//  bookInfo.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/1.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
书籍的详细信息获取
———————————————————————————————————————*/
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreData
class bookInfo: UIViewController, UITableViewDataSource, UITableViewDelegate {
//UI控件配置
    @IBOutlet weak var imgename: UIImageView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var bookname: UILabel!
    @IBOutlet weak var bookauthor: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var bind: UILabel!

    
    var booksname: String!
    

    var bookdetail :NSMutableDictionary = ["":""]
    var itemname:NSArray = ["出版年:","页数:","定价:","内容简介:","ISBN: "]
    var enitemname:NSArray = ["pubdate","pages","price","summary","isbn13"]
    
    override func viewDidLoad() {
    super.viewDidLoad()
    //self sizing cell
    TableView.estimatedRowHeight = 40
    TableView.rowHeight = UITableViewAutomaticDimension
    
        

    //MBprocess
    var HUD = MBProgressHUD()
    HUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
    HUD.labelText = "正在获取书籍信息···"
    self.TableView.addSubview(HUD)
    HUD.show(true)
    //网络请求
    Alamofire.request(doubanRouter.searchBook(["q":"\(booksname)", "apikey":"021ee6fe92aee6a4065cb4fbb80cb3ec"])).responseJSON { (_, _, json, _)  in
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
       

        if var imgL = jsondata["books"][0]["images"]["large"].string{
            var imgurl = NSURL(string: imgL)
            self.imgename.sd_setImageWithURL(imgurl)
        }

        
        
        if var tit = jsondata["books"][0]["title"].string{
            self.bookname.text = "书名:\(tit)"
        }else{self.bookname.text = "-"}
        if var auth = jsondata["books"][0]["author"].string{
            self.bookauthor.text = "作者:\(auth)"
        }else{self.bookauthor.text = "-"}
        if var pub = jsondata["books"][0]["publisher"].string{
            self.publisher.text = "出版社:\(pub)"
        }else{self.publisher.text = "-"}
        if var bind = jsondata["books"][0]["binding"].string{
            self.bind.text = "装帧:\(bind)"
        }else{self.bind.text = "-"}
        
        //刷新数据
        self.TableView.reloadData()
        HUD.hide(true)
        
        }
        
       
        
      
        
    }
    
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
