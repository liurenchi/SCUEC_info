//
//  favNewsDetailView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/5.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit

class favNewsDetailView: UITableViewController
{

    
    var newstitle:String!
    var newsdetail:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self sizing cell
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension


     
    }

    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
  
// MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! newsDetailCell

       cell.title.text = newstitle
        cell.newsdetail.text = newsdetail

        return cell
    }


   
}
