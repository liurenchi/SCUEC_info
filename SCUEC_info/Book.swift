//
//  Book.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/27.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import Foundation
import CoreData

class Book: NSManagedObject {

    @NSManaged var author: String
    @NSManaged var borrowdate: String
    @NSManaged var codenum: String
    @NSManaged var duedate: String
    @NSManaged var location: String
    @NSManaged var name: String
    @NSManaged var checknumber: String
    @NSManaged var shelves: Shelves

}
