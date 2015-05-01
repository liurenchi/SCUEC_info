//
//  favoriteBookView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/1.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit

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
        
        cell.bookname.text = self.favbook[indexPath.row].name
        cell.author.text = self.favbook[indexPath.row].author
        return cell
    }
    
// MARK: - Navigation
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showbookInfo" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as! bookInfo
                destinationController.bookname = self.favbook[row].name

            }
        }

    }
   

}
