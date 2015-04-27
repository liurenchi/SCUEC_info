//
//  currentBookView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
当前借阅书籍的数据展示，其中数据获取等操作方法见libconfig/curbook_request.swift
———————————————————————————————————————*/
import UIKit
import Alamofire
import CoreData
class currentBookView: UITableViewController
{
    var book:[Book]!
    
   
        override func viewDidLoad() {
        super.viewDidLoad()
        // Self Sizing Cells
        
        //AlamofireRequest()
        
        book = fetchCoreData("book_FetchRequest") as! [Book]
        
        for obj in book{
            println(obj.codenum)
        }
            func viewDidAppear(animated: Bool) {
                
                self.tableView.reloadData()
                
            }
    }



    
    
// MARK: - Table view data source

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return book.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! curBookCell
        
    //配置cell数据
        cell.bookname.text = "《\(book[indexPath.row].name)》"
        cell.bookauthor.text = book[indexPath.row].author
        cell.borrowdate.text = "借阅日期:\(book[indexPath.row].borrowdate)"
        cell.duedate.text = "到期日期:\(book[indexPath.row].duedate)"
    
    return cell
    }
   
    
//MARK: - tableviewcell的操作
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath:NSIndexPath) -> [AnyObject] {
        
        var pinbookAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "添加到书架", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 添加书籍到书架
            
            })
        var renewAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,
            title: "续借",handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //续借功能
            })
    return [pinbookAction,renewAction]
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
                
                
    }
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
