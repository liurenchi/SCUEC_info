//
//  currentBookView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
当前借阅书籍的数据展示，其中数据获取等操作方法见libconfig/curbook_request.swift
-续借功能，通过http请求进行续借
-添加到书架功能，添加到favorites的coredata中储存
———————————————————————————————————————*/
import UIKit
import Alamofire
import CoreData
import MBProgressHUD
import PZPullToRefresh
class currentBookView: UITableViewController, PZPullToRefreshDelegate
{
    var book: [Book]!
    var favbook: Favorites!
    //coreDataStack实例
    var coreDataStack: CoreDataStack = CoreDataStack()
    //NSManagedObjectContext实例赋值在了savecoredata方法中
    var managedObjectContext: NSManagedObjectContext!

    var refreshHeaderView: PZPullToRefreshView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        book = fetchCoreData("book_FetchRequest") as! [Book]
        managedObjectContext = coreDataStack.context
       self.edgesForExtendedLayout = UIRectEdge.None
        
        
   
    }

    override func viewWillAppear(animated: Bool) {
        if refreshHeaderView == nil {
            var view = PZPullToRefreshView(frame: CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            view.delegate = self
            self.tableView.addSubview(view)
            refreshHeaderView = view
        }    }
   


    
    
// MARK: - Table view data source

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return book.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! curBookCell
        
    //配置cell数据
        cell.bookname.text = "《\(book[indexPath.row].name)》"
        cell.bookauthor.text = book[indexPath.row].author
        cell.borrowdate.text = "借阅日期:\(book[indexPath.row].borrowdate)"
        cell.duedate.text = "到期日期:\(book[indexPath.row].duedate)"

        
    return cell
    }
   
    
//MARK: - tableviewcell的操作
//-添加书籍到书架
//- 续借功能
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath) -> [AnyObject] {
        
        var pinbookAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "添加到书架", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
           
             self.favbook = NSEntityDescription.insertNewObjectForEntityForName("Favorites", inManagedObjectContext: self.managedObjectContext) as! Favorites
             self.favbook.name = self.book[indexPath.row].name
             self.favbook.author = self.book[indexPath.row].author
             var e: NSError?
             if self.managedObjectContext.save(&e) != true {
                println("curbook中存储coredata出错insert error: \(e!.localizedDescription)")
             }
             tableView.editing = false
            })
        
        var renewAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,
            title: "续借",handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            self.renewBook(indexPath.row)
             tableView.editing = false
            })
        
        pinbookAction.backgroundColor = UIColor(red: 255/255, green: 97/255, blue: 0, alpha: 1)
        renewAction.backgroundColor = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
    return [pinbookAction,renewAction]
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
                
    }
    

//MARK: - 按钮功能
    func renewBook(renewId: Int){
        var get1970_time: NSTimeInterval = NSDate().timeIntervalSince1970 * 1000
        var codenum = book[renewId].codenum
        var checknum = book[renewId].checknumber
        Alamofire.request(Router.RenewBook(["bar_code":"\(codenum)","check":"\(checknum)","time":"\(get1970_time)"])).responseString(encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
            // 测试
            println(string)
        }).response { (request, response, _, error) -> Void in
            println(request)
            
        }
  
    }
   
// MARK: - 下拉刷新配置
    // MARK:UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
    }
    
    // MARK:PZPullToRefreshDelegate

    func pullToRefreshDidTrigger(view: PZPullToRefreshView) -> () {
        refreshHeaderView?.isLoading = true
        println("fuck!")
        
            Alamofire.request(Router.GetCurrentBook).response({ (_, _, data, error) in
                if error != nil {
                    println("当前借阅请求错误")
                    self.refreshHeaderView?.isLoading = false
                    self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)

                }else{
                    if data != nil {
                        var parsedata = data as! NSData
                        var tableData = parseTableData(parsedata)
                        var btnData = parseBtnData(parsedata)
                        if updataCoreData(){
                            savetoCoredata(tableData, btnData)}
                        self.book = fetchCoreData("book_FetchRequest") as! [Book]
                        println(self.book[0].codenum)
                        println("Complete loading!")
                        self.refreshHeaderView?.isLoading = false
                        self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
                        println("reload!!!!!")
                        self.tableView.reloadData()
                        
                    }}
            })
        
        
        
    }

    // Optional method
    
    func pullToRefreshLastUpdated(view: PZPullToRefreshView) -> NSDate {
        return NSDate()
    }
    
    
    
    
    
}
