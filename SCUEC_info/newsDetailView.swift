
//
//  newsDetailView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/2.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import MBProgressHUD
class newsDetailView: UITableViewController
{

    var newsurl:String!
    var newstitle:String!
    var newsdetail:String!
    var newstime:String!
    
    //coreDataStack实例
    var coreDataStack: CoreDataStack = CoreDataStack()
    //NSManagedObjectContext实例赋值在了savecoredata方法中
    var managedObjectContext: NSManagedObjectContext!
    var news: News!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self sizing cell
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
          managedObjectContext = coreDataStack.context
        
        var range = NSRange(location: 0, length: 1)
//        var requestUrl = self.newsurl.stringByReplacingCharactersInRange(range, withString: "http://news.scuec.edu.cn/xww")
        var requestUrl = newsurl.stringByReplacingOccurrencesOfString("./", withString: "http://news.scuec.edu.cn/xww/")
       
        Alamofire.request(.GET, "\(requestUrl)").response { (_, _, data, error) in
            
            if error != nil {
                println("新闻详情请求错误")
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "新闻详情请求错误"
                self.tableView.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 2)
            }else{
                if data != nil {
                    var parsedata = data as! NSData
                    self.parseNewsDetail(parsedata)
                    
                    
                }}
        }

    
    }
//MARK: - 保存新闻
    @IBAction func saveNews(sender: UIBarButtonItem) {
        
        
        news = NSEntityDescription.insertNewObjectForEntityForName("News", inManagedObjectContext: managedObjectContext) as! News

        news.title = newstitle
        news.passage = newsdetail
        news.time = newstime
        
        //成功提示
        var succeedHUD = MBProgressHUD()
        succeedHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
        succeedHUD.labelText = "收藏成功！"
        succeedHUD.customView = UIImageView(image: UIImage(named: "Checkmark"))
        succeedHUD.mode = MBProgressHUDMode.CustomView
        self.view.addSubview(succeedHUD)
        succeedHUD.show(true)
        succeedHUD.hide(true, afterDelay: 2)
        
        var e: NSError?
        if managedObjectContext.save(&e) != true {
            println("curbook中存储coredata出错insert error: \(e!.localizedDescription)")
            //错误提示
            var errorHUD = MBProgressHUD()
            errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
            errorHUD.labelText = "储存出错！"
            self.tableView.addSubview(errorHUD)
            errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
            errorHUD.mode = MBProgressHUDMode.CustomView
            errorHUD.show(true)
            errorHUD.hide(true, afterDelay: 2)
        }

    }
    
    
    
//MARK:- TFHpple解析方法
    func parseNewsDetail(data:NSData){
        
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin newsdetailparse!")
        var loop:Int = 1
        
            if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='container']/section/article/div[3]") {
                //文本调整
                newsdetail = output.content.stringByReplacingOccurrencesOfString("分享到：", withString: "")
               
            
            }else{
                println("获取新闻详情数据出错")
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "获取新闻详情数据出错"
                self.view.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 3)
        
        }
        
        self.tableView.reloadData()
    }
    
    
    
    
    
// MARK: - Table view data source

   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! newsDetailCell

        switch indexPath.row {
        case 0:
            cell.title.text = "\(self.newstitle)"
            cell.newsdetail.text = "\(self.newsdetail)"
        default:
            cell.title.text = ""
            cell.newsdetail.text = ""
        }

        
        
        return cell
    }


   }
