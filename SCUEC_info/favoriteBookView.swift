//
//  favoriteBookView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/1.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
被收藏到书架的书籍展示，点击cell进入详细信息
———————————————————————————————————————*/
import UIKit
import Alamofire
import SwiftyJSON
import CoreData
class favoriteBookView: UITableViewController
{
    var favbooks: [Favorites]!
    var favbook: Favorites!
 
    //coreDataStack实例
    var coreDataStack: CoreDataStack = CoreDataStack()
    //NSManagedObjectContext实例赋值在了savecoredata方法中
    var managedObjectContext: NSManagedObjectContext!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = coreDataStack.context
        favbooks = fetchfavebookData("favor_FetchRequest") as! [Favorites]
        
        

    
    
    }
        
    
    
    
    
    
    
    
    
    
    
    
    

// MARK: - Table view data source



     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return favbooks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! bookInfoCell
        
        if var bookrequestname = self.favbooks[indexPath.row].name{
        
       
        //网络请求
            Alamofire.request(doubanRouter.searchBook(["q":"\(bookrequestname)", "apikey":"021ee6fe92aee6a4065cb4fbb80cb3ec"])).responseJSON { (_, _, json, _)  in
                
               
                //返回数据不为nil则解析，coredata操作
                    if json != nil {
                    var jsondata = JSON(json!)
                        if var imgM = jsondata["books"][0]["images"]["medium"].string{
                            var imgurl = NSURL(string: imgM)
                            // 存入coredata
                           
                            self.favbooks[indexPath.row].imgurlM = imgM
                            var e: NSError?
                                if self.managedObjectContext.save(&e) != true {
                                    println("favbook中存储coredata出错 error: \(e!.localizedDescription)")}
                            //cell config
                            cell.bookimg.sd_setImageWithURL(imgurl)
                        }
                    }else{
                        if var imgurl = self.favbooks[indexPath.row].imgurlM{
                            cell.bookimg.sd_setImageWithURL(NSURL(string:imgurl))}}
            }
        
    
        cell.bookname.text = self.favbooks[indexPath.row].name
        cell.author.text = self.favbooks[indexPath.row].author
        }
        return cell
    }
    
// MARK: - Navigation
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showbookInfo" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as! bookInfo
                destinationController.booksname = self.favbooks[row].name

            }
        }
    }
   
//MARK:获取
    func fetchfavebookData(TemplateForName: String) -> [NSManagedObject]?{
        //获取方法初始化
        var fetchRequest: NSFetchRequest!
        fetchRequest = coreDataStack.model.fetchRequestTemplateForName(TemplateForName)
        var error: NSError?
        let results = coreDataStack.context.executeFetchRequest(fetchRequest,error: &error) as? [Favorites]
        if let fetchedResults = results {
            // books = fetchedResults
            return fetchedResults
            //store the fetched results in the venues property you defined earlier
        } else {
            println("curbook数据获取失败：Could not fetch \(error), \(error!.userInfo)")
            return nil
        }
        
    }


}
