//
//  Favorites.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/1.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import Foundation
import CoreData

class Favorites: NSManagedObject {

    @NSManaged var author: String
    @NSManaged var author_intro: String
    @NSManaged var name: String?
    @NSManaged var pubdate: String
    @NSManaged var publisher: String
    @NSManaged var summary: String
    @NSManaged var imgurlL: String
    @NSManaged var imgurlM: String?
    @NSManaged var translator: String
    @NSManaged var isbn13: String
    @NSManaged var price: String
    @NSManaged var pages: String
    @NSManaged var binding: String

}
