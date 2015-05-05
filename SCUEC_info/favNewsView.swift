//
//  favNewsView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/5.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import CoreData
class favNewsView: UITableViewController
{
    //coreDataStack实例
    var coreDataStack: CoreDataStack = CoreDataStack()
    //NSManagedObjectContext实例赋值在了savecoredata方法中
    var managedObjectContext: NSManagedObjectContext!


    var favnews: [News]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = coreDataStack.context
        favnews = fetchfavNewsData("news_FetchRequest") as! [News]
        
        

    }


// MARK: - Table view data source

  

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return favnews.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! newsTableCell
        cell.newstitle.text = favnews[indexPath.row].title
        cell.newstime.text = favnews[indexPath.row].time
        
        
        
        

        return cell
    }

    // MARK: - 导航
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showfavnews" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as! favNewsDetailView
                    destinationController.newsdetail = favnews[row].passage
                    destinationController.newstitle = favnews[row].title
                
            }
        }
    }
    
    
    
    
    
    //MARK:获取fav新闻
    func fetchfavNewsData(TemplateForName: String) -> [NSManagedObject]?{
        //获取方法初始化
        var fetchRequest: NSFetchRequest!
        fetchRequest = coreDataStack.model.fetchRequestTemplateForName(TemplateForName)
        var error: NSError?
        let results = coreDataStack.context.executeFetchRequest(fetchRequest,error: &error) as? [News]
        if let fetchedResults = results {
            // books = fetchedResults
            return fetchedResults
            //store the fetched results in the venues property you defined earlier
        } else {
            println("favNews数据获取失败：Could not fetch \(error), \(error!.userInfo)")
            return nil
        }
        
    }

}
