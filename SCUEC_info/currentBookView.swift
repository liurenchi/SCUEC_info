//
//  currentBookView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
class currentBookView: UITableViewController
{
    var book: Book!
    var shelve: Shelves!
    var bookss: [Shelves]!
    var fetchRequest: NSFetchRequest!
    var coreDataStack: CoreDataStack = CoreDataStack()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(Router.GetCurrentBook).responseString (encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
            // println(string)
        }).response({ (_, _, data, _) in
            if data != nil {
                var parsedata = data as! NSData
                self.parseData(parsedata)
            }
        })
        
        fetchRequest = coreDataStack.model.fetchRequestTemplateForName("FetchRequest")
       

    }

    func fetchAndReload(){
        var error: NSError?
        let results = coreDataStack.context!.executeFetchRequest(fetchRequest,error: &error) as! [Shelves]?
        if let fetchedResults = results {
           bookss = fetchedResults
            //store the fetched results in the venues property you defined earlier
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        println(bookss[0].bookname.codenum)
    }

    func parseData(data:NSData){
        
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin parse!")
        if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='mylib_content']/table") {
           
            //字符串筛选
            var string = output.content.stringByReplacingOccurrencesOfString("\t", withString: "")
            var string1 = string.stringByReplacingOccurrencesOfString("\n", withString: "")
            var string2 = string1.stringByReplacingOccurrencesOfString("\r", withString: "|")
            //字符串存入数组并转化为可变
            var nsArray: NSArray = string2.componentsSeparatedByString("|")
            var strArray = nsArray.mutableCopy() as! NSMutableArray
            //有用数据开始的元素索引
            var usefulindex: Int!
            //找到有用数据的下标
            for array in strArray{
                
                if isPureNumandCharacters(array as! String){
                    usefulindex = strArray.indexOfObject(array)
                    //println(usefulindex)
                    break
                }
            }
            //删除无用数据
            var loop = usefulindex - 1
            for (var i = loop ; i >= 0; i--){
                strArray.removeObjectAtIndex(i)
            }
           //存入本地
            self.savetoCoredata(strArray)
        }else{
            println("nil")
        }
        
    }
    //存入coredata
    func savetoCoredata(array: NSMutableArray){
       
        
        if let managedObjectContext = coreDataStack.context {
            
            book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: managedObjectContext) as! Book
            
           book.codenum = array[0] as! String
            shelve = NSEntityDescription.insertNewObjectForEntityForName("Shelves", inManagedObjectContext: managedObjectContext) as! Shelves
            
            shelve.bookname = book
            
            
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            }
            
          
        }
    
         fetchAndReload()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
