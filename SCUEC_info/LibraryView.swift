//
//  LibraryView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/19.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
Lib的主界面，界面ui在storyboard中实现
———————————————————————————————————————*/
import UIKit
import Alamofire
class LibraryView: UITableViewController {
    var UserName: String! //用户名
    var PassWord: String! //密码
    var UserNameType: String! //用户名类型
    //初始化 NSUserDefaults
    let defaults = NSUserDefaults.standardUserDefaults()
    var autologinnumeber: Bool = true //自动登录
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.revealViewController().rearViewRevealWidth = 240
        
// MARK: -
        
// MARK: -  自动登录
        
        if autologinnumeber {
            var logintype = defaults.stringForKey("auto_login")
            
            if logintype == "auto_login"{
                var nametype = defaults.stringForKey("UsernameType")
                getUserData() //数据处理
                userLogin(UserName,password: PassWord,type: UserNameType) //网络请求
                autologinnumeber = false
            }
        }
    }

    
    func getUserData() {

            UserName = defaults.stringForKey("Username")
            PassWord = defaults.stringForKey("Password")
            UserNameType =  defaults.stringForKey("UsernameType")
        
            

        
        
        
    }

// MARK: - 登录请求
    func userLogin(username:String, password:String, type:String) {
        Alamofire.request(Router.LoginUser(["number":"\(username)", "passwd":"\(password)", "select":"\(type)"])).responseString(encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
            // 测试
            //println(string)
        }).response { (_, _, data, error) -> Void in
            if data != nil { //测试登录情况
                var parsedata = data as! NSData
                self.parseData(parsedata)
            }

            if error != nil {
                println("登录请求错误")
                }
            self.dismissViewControllerAnimated(true, completion: nil)

            }
        }
    
   // MARK: - 测试登录情况
    func parseData(data:NSData){
        //解析获取的数据
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin parse用户信息!")
        if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='mylib_content']/div[1]") {
            println("用户登录成功！！！")
          
        }else{
            println("用户登录失败！！！")
        }
    }

    



}
