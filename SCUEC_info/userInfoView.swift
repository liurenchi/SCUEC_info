//
//  userInfoView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/23.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
用户基本信息的请求，当前的借阅情况的简单返回
———————————————————————————————————————*/
import UIKit
import Alamofire
import MBProgressHUD
class userInfoView: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var Tableview: UITableView!
    
    var userinfo:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //用户信息获取
        Alamofire.request(Router.GetUserInfo).responseString (encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
             //测试      // println(string)
            }).response({ (_, _, data, _) in
            if data != nil {
                var parsedata = data as! NSData
                 self.parseData(parsedata)
            }else{
                println("用户信息获取失败")
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "用户信息获取失败 (╯‵□′)╯︵┻━┻ "
                self.Tableview.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 3)

                
                }
            })

    }

  // MARK: - 解析获取的数据
    func parseData(data:NSData){
        
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin parse用户信息!")
        if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='mylib_content']/div[1]") {
            //字符串筛选
            var string = output.content.stringByReplacingOccurrencesOfString("\t", withString: "")
            var string1 = string.stringByReplacingOccurrencesOfString("\n", withString: "")
            var string2 = string1.stringByReplacingOccurrencesOfString("\r", withString: "，")
            
            var infotemp = string2.componentsSeparatedByString("，") as NSArray //主要逗号的中英文
            userinfo = infotemp.mutableCopy() as! NSMutableArray
            userinfo.removeLastObject()
            println("用户信息parse end")
            self.Tableview.reloadData()
            }else{
                println("userinfo数据解析为nil")
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "用户信息数据解析失败"
                self.Tableview.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 3)
            }
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        cell.textLabel?.text = userinfo[indexPath.row] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userinfo.count
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
