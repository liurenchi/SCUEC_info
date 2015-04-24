//
//  Book.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/24.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import Foundation
import CoreData

class Book: NSManagedObject {

    @NSManaged var borrowdate: String
    @NSManaged var location: String
    @NSManaged var codenum: String
    @NSManaged var duedate: String
    @NSManaged var name: String
    @NSManaged var author: String
    @NSManaged var shelves: Shelves

}
