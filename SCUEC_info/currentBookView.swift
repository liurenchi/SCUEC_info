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
    var book: Book!
    var shelve: Shelves!
    var books: [Shelves]!
    var fetchRequest: NSFetchRequest!
    var coreDataStack: CoreDataStack = CoreDataStack()
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = coreDataStack.context
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
        let results = coreDataStack.context.executeFetchRequest(fetchRequest,error: &error) as! [Shelves]?
        if let fetchedResults = results {
           books = fetchedResults
            //store the fetched results in the venues property you defined earlier
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

//        for(var i = 0;i < books.count; i++){
//                println(books[i].bookname.codenum)
//                println("--------")
//        }
      
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
//            //有用数据开始的元素索引
//            var usefulindex: Int!
//            //找到有用数据的下标
//            for array in strArray{
//                
//                if isPureNumandCharacters(array as! String){
//                    usefulindex = strArray.indexOfObject(array)
//                    //println(usefulindex)
//                    break
//                }
//            }
//            //删除无用数据
//            var loop = usefulindex - 1
//            for (var i = loop ; i >= 0; i--){
//                strArray.removeObjectAtIndex(i)
//            }
            for arry in strArray{
                println(arry)
            }
            
           //存入本地
            self.savetoCoredata(strArray)
        }else{
            println("nil")
        }
        
    }
    //存入coredata
    func savetoCoredata(saveArray: NSMutableArray){
       
        
        
        
            //将数组的数据存入entity
        var usefulindex: Int = 0
        var keep_do:Bool = true
        //存储数据进入coredata
        do{
            //找到书号即为第一个有效数据
            for array in saveArray {
                if isPureNumandCharacters(array as! String){
                    usefulindex = saveArray.indexOfObject(array)
                    keep_do = true
                    break
                }
                keep_do = false
            }
        if(keep_do){
            //通过分析返回的数据，然后按照格式存入coredata
            book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: managedObjectContext) as! Book
            shelve = NSEntityDescription.insertNewObjectForEntityForName("Shelves", inManagedObjectContext: managedObjectContext) as! Shelves

            book.codenum = saveArray[usefulindex] as! String
            var name_author = (saveArray[usefulindex+1] as! String).componentsSeparatedByString("/")
            book.name = name_author[0]
            book.author = name_author[1]
            book.borrowdate = saveArray[usefulindex+2] as! String
            book.duedate = saveArray[usefulindex+3] as! String
            book.location = saveArray[usefulindex+5] as! String
            var range:NSRange = NSRange(location:usefulindex, length:7)
            saveArray.removeObjectsInRange(range)}
        }while(keep_do)
        
        
        
        
        println("end_save")
        
        
        
            var e: NSError?
            if managedObjectContext.save(&e) != true {
                println("insert error: \(e!.localizedDescription)")
                return
            
            
          
        }
    
         fetchAndReload()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
