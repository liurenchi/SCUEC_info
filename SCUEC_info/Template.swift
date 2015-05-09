//
//  Template.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/27.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//






/*



//进度提示
var HUD = MBProgressHUD()
HUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
HUD.labelText = "正在登录···"
self.view.addSubview(HUD)
HUD.show(true)
HUD.hide(true)

//错误提示
var errorHUD = MBProgressHUD()
errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
errorHUD.labelText = "error···"
self.view.addSubview(errorHUD)
errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
errorHUD.mode = MBProgressHUDMode.CustomView
errorHUD.show(true)
errorHUD.hide(true, afterDelay: 3)


//成功提示
var succeedHUD = MBProgressHUD()
succeedHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
succeedHUD.labelText = "用户登录成功！"
succeedHUD.customView = UIImageView(image: UIImage(named: "Checkmark"))
succeedHUD.mode = MBProgressHUDMode.CustomView
self.view.addSubview(succeedHUD)
succeedHUD.show(true)
succeedHUD.hide(true, afterDelay: 2)





"书名:","作者:","出版社:",
"title","author","publisher",

//NSDate的格式转化

    var time = "2015-05-12 15:07:02"
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
    var date = dateFormatter.dateFromString(time)!



//导航栏的返回按钮
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()


// MARK: - prepareForSegue


override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
if segue.identifier == "showbookInfo" {
if let row = tableView.indexPathForSelectedRow()?.row {
let destinationController = segue.destinationViewController as! bookInfo
destinationController.booksname = self.favbook[row].name

}
}
}

//MARK:- TFHpple解析方法
func parseNewsDetail(data:NSData){

var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
println("begin newstableparse!")
var loop:Int = 1

if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='container']/section/article/div[3]") {



}else{
println("获取新闻列表数据出错")}

self.tableView.reloadData()
}





*/*/