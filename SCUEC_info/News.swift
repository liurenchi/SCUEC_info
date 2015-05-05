//
//  News.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/5.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import Foundation
import CoreData

class News: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var passage: String
    @NSManaged var time: String

}
