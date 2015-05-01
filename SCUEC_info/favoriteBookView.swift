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
class favoriteBookView: UITableViewController
{
    var favbook: [Favorites]!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favbook = fetchCoreData("favor_FetchRequest") as! [Favorites]
    
        
    
    
    
    }
        
    
    
    
    
    
    
    
    
    
    
    
    

// MARK: - Table view data source



     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return favbook.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! bookInfoCell
        //网络请求
        Alamofire.request(doubanRouter.searchBook(["q":"\(self.favbook[indexPath.row].name)", "apikey":"021ee6fe92aee6a4065cb4fbb80cb3ec"])).responseJSON { (_, _, json, _)  in
            var jsondata = JSON(json!)
            if var imgM = jsondata["books"][0]["images"]["medium"].string{
                var imgurl = NSURL(string: imgM)
                cell.bookimg.sd_setImageWithURL(imgurl)
            }
        }

        cell.bookname.text = self.favbook[indexPath.row].name
        cell.author.text = self.favbook[indexPath.row].author
        return cell
    }
    
// MARK: - Navigation
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showbookInfo" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as! bookInfo
                destinationController.booksname = self.favbook[row].name

            }
        }

    }
   

}
