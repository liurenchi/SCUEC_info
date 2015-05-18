//
//  addBookView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/17.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
搜索书籍，然后加入我的书架列表
———————————————————————————————————————*/
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreData
class addBookView: UITableViewController, UISearchBarDelegate
{
  
    
    //coreDataStack实例
    var coreDataStack: CoreDataStack = CoreDataStack()
    //NSManagedObjectContext实例赋值在了savecoredata方法中
    var managedObjectContext: NSManagedObjectContext!

    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchdatas: [Searchresult]! //搜索结果数组
    var searchdata: Searchresult! //搜索结果class
    var refresh: Bool = false //search刷新
  
    
    var favbook: Favorites!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchbar
        searchBar.delegate = self
        //searchBar.barTintColor = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
        self.searchdatas = []
        searchdata = Searchresult()
        
        
        // coredata
        managedObjectContext = coreDataStack.context
               

        
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //进度提示
    var HUD = MBProgressHUD()
    HUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
    HUD.labelText = "正在登录···"
    self.view.addSubview(HUD)
    HUD.show(true)
    
    //隐藏键盘，清空数组
    searchBar.resignFirstResponder()
    self.searchdatas = []
    //搜索的词
    let searchText = searchBar.text
    
        //网络请求
        Alamofire.request(doubanRouter.searchBook(["q":"\(searchText)", "apikey":"021ee6fe92aee6a4065cb4fbb80cb3ec"])).responseJSON { (_, _, json, _)  in
            
            if json != nil {
                var jsondata = JSON(json!)
                var countstring = jsondata["count"].stringValue
                //循环解析json
                if var datacount = String(countstring).toInt(){
                    var loopnumber = 0
                    for (loopnumber; loopnumber < datacount; loopnumber++){
                        if var imgM = jsondata["books"][loopnumber]["images"]["small"].string{
                            self.searchdata.imgurlS = imgM}
                        if var bookname = jsondata["books"][loopnumber]["title"].string{
                            self.searchdata.name = bookname}
                        if var author = jsondata["books"][loopnumber]["author"][0].string{
                            self.searchdata.author = author}
                        self.searchdatas.append(self.searchdata)
                    }
                   //tableview的reload
                    self.refresh = true
                    self.tableView.reloadData()
                    HUD.hide(true)

  
                }
            }
        }
        
       
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath) -> [AnyObject] {
        
        var pinbookAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "添加到书架", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            if self.searchdatas[indexPath.row].isadd{
                //避免重复添加
            }else{
                self.favbook = NSEntityDescription.insertNewObjectForEntityForName("Favorites", inManagedObjectContext: self.managedObjectContext) as! Favorites
                self.favbook.name = self.searchdatas[indexPath.row].name
                self.favbook.author = self.searchdatas[indexPath.row].author
                // 标记已经添加
                self.searchdatas[indexPath.row].isadd = true
                
                var e: NSError?
                if self.managedObjectContext.save(&e) != true {
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
            
                tableView.editing = false
            }
        })
        pinbookAction.backgroundColor = UIColor(red: 255/255, green: 97/255, blue: 0, alpha: 1)
       
        return [pinbookAction]
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
        
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return searchdatas.count
     
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! searchbookCell

        if refresh{
            var imgurl = NSURL(string: searchdatas[indexPath.row].imgurlS)
            cell.bookimg.sd_setImageWithURL(imgurl)
            cell.author.text = searchdatas[indexPath.row].author
            cell.bookname.text = "《\(searchdatas[indexPath.row].name)》"

        }
        return cell
    }



//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            
//            
//        
//            
//            
//            
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
