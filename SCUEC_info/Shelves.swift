//
//  Shelves.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import Foundation
import CoreData

class Shelves: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var bookname: Book

}
