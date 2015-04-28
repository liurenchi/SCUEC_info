//
//  curbook_request.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/26.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

/*———————————————————————————————————————
currentBookView的的数据操作方法：
包括Alamofire的请求，还有TFHpple解析，以及数据通过coredata的本地化存储获取更新
———————————————————————————————————————*/

import Foundation
import Alamofire
import CoreData


//coreDataStack实例
var coreDataStack: CoreDataStack = CoreDataStack()
//NSManagedObjectContext实例赋值在了savecoredata方法中
var managedObjectContext: NSManagedObjectContext!



//MARK:- TFHpple解析方法
func parseTableData(data:NSData) -> (NSMutableArray){
    
    var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
    println("begin tableparse!")
    if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='mylib_content']/table") {
        //字符串筛选
        var string = output.content.stringByReplacingOccurrencesOfString("\t", withString: "")
        var string1 = string.stringByReplacingOccurrencesOfString("\n", withString: "")
        var string2 = string1.stringByReplacingOccurrencesOfString("\r", withString: "|")
        //字符串存入数组并转化为可变
        var nsArray: NSArray = string2.componentsSeparatedByString("|")
        var strArray = nsArray.mutableCopy() as! NSMutableArray
        /* 调试
        for arry in strArray{
            println(arry)
          }*/
        
       
        //存入本地
        return (strArray)
        }else{
        println("nil")
        return ([])
        
    }
    
}
func parseBtnData(data:NSData) -> (NSMutableArray){
    var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
    println("begin btnparse!")
    //获取续借按钮的参数
    var loopnumber: Int = 1
    var btnArray: NSMutableArray = []
    do{
        if var input:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='\(loopnumber)']/input"){
            var temp = input.attributes["onclick"] as! String
            var temparray: NSArray = temp.componentsSeparatedByString("'")
            btnArray.addObject(temparray[3])
            loopnumber++}else{println("获取续借按钮的参数出错")}
    }while(loopnumber < 8   )
    return(btnArray)
}
//MARK:- CoreData操作
//MARK: 存储


func savetoCoredata(saveArray: NSMutableArray, btnarray: NSMutableArray) {
    //将数组的数据存入entity
    //赋值Context
     managedObjectContext = coreDataStack.context
    //定义NSManagedObject
    var book: Book!
    var shelve: Shelves!
    //3个标志信号量
    var usefulindex: Int = 0//找到有效数据（即全数字开头）
    var keep_do:Bool = true//流程控制
    var btndataindex: Int = 0//续借按钮中的参数存在btnarray中的索引
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
            
            book.checknumber = btnarray[btndataindex] as! String
            btndataindex++
            book.codenum = saveArray[usefulindex] as! String
            var name_author = (saveArray[usefulindex+1] as! String).componentsSeparatedByString("/")
            book.name = name_author[0]
            book.author = name_author[1]
            book.borrowdate = saveArray[usefulindex+2] as! String
            book.duedate = saveArray[usefulindex+3] as! String
            book.location = saveArray[usefulindex+5] as! String
            shelve.bookname = book // relationships
            var range:NSRange = NSRange(location:usefulindex, length:7)
            saveArray.removeObjectsInRange(range)}
        
    }while(keep_do)
    println("end_save")
    
    //错误处理
    var e: NSError?
    if managedObjectContext.save(&e) != true {
        println("curbook中存储coredata出错insert error: \(e!.localizedDescription)")
    }
}
//MARK:更新
func updataCoreData() -> Bool{
    //如果coredata中有数据就删掉
    managedObjectContext = coreDataStack.context
    if fetchCoreData("FetchRequest") != nil{
        //从获取shelves中的数据中删除
        if let fetchresults = fetchCoreData("FetchRequest"){
            for book in fetchresults{
                managedObjectContext.deleteObject(book)
            }
        }
         //从获取book中的数据中删除
        if let fetchresults = fetchCoreData("book_FetchRequest"){
            for book in fetchresults{
                managedObjectContext.deleteObject(book)
            }
        }
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("更新删除失败: \(error)")
        }
    }
    return true
}

//MARK:获取
func fetchCoreData(TemplateForName: String) -> [NSManagedObject]?{
    //获取方法初始化
    var fetchRequest: NSFetchRequest!
    fetchRequest = coreDataStack.model.fetchRequestTemplateForName(TemplateForName)
    var error: NSError?
    let results = coreDataStack.context.executeFetchRequest(fetchRequest,error: &error) as! [Book]?
    if let fetchedResults = results {
       // books = fetchedResults
        return fetchedResults
        //store the fetched results in the venues property you defined earlier
    } else {
        println("curbook数据获取失败：Could not fetch \(error), \(error!.userInfo)")
        return nil
    }
   
}




