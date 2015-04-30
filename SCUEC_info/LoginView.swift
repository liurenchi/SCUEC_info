//
//  LoginView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/20.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
登陆view的实现方式，里面通过输入用户名密码和其他配置，通过Alamofire请求数据
同时操作储存cookies用于context中请求用
———————————————————————————————————————*/
import UIKit
import Alamofire
import MBProgressHUD
class LoginView: UIViewController
{
//MARK:- 数据属性
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var remPassword: UISwitch!
    @IBOutlet weak var usernameType: UISegmentedControl!
    var UserName: String! //用户名
    var PassWord: String! //密码
    var UserNameType: String! //用户名类型
    enum userType: String { //账号类型枚举
        case bar_code = "barcode"
        case st_number = "stnumber"
    }
    
    
//MARK:- 功能按钮实现
    @IBAction func loginButton() {
        
        
        saveUserData() //数据处理
        UserName = "11121027"
        PassWord = "2"
        UserNameType = "cert_no"
        userLogin(UserName,password: PassWord,type: UserNameType) //网络请求
    }
    func netrequest(){
    
    }
    @IBAction func cancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        

//MARK:- 具体功能实现
    func saveUserData() {
        //初始化 NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        // 有输入且选择了记住密码
        
        if !Username.text.isEmpty && !Password.text.isEmpty {
            if remPassword.on{ //记住密码
            defaults.setObject(Username.text, forKey: "Username")
            defaults.setObject(Password.text, forKey: "Password")
            UserName = defaults.stringForKey("Username")!
            PassWord = defaults.stringForKey("Password")!
            }else { //不记住密码
                UserName = Username.text
                PassWord = Password.text
                 defaults.setObject("", forKey: "auto_login")
                
            }
        }else{
            println("错误的用户名或密码输入")
        }
        
        // 设置用户名类型
        if usernameType.selectedSegmentIndex == 0 {
            UserNameType = "cert_no"
        }else if usernameType.selectedSegmentIndex == 1 {
            UserNameType = "bar_no"
        }
        
        defaults.setObject(UserNameType, forKey: "UsernameType")

       // 清空之前的cookies，马上保存
        defaults.setObject(nil, forKey: "Cookie_name")
        defaults.setObject(nil, forKey: "Cookie_value")
        defaults.synchronize()

    }
    
    
    func userLogin(username:String, password:String, type:String) {
 
        //类型转换
//        println(password)
//        println("\(username)")
        
        //进度提示
        var HUD = MBProgressHUD()
        HUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
        HUD.labelText = "正在登录···"
        self.view.addSubview(HUD)
        HUD.show(true)
        Alamofire.request(Router.LoginUser(["number":"\(username)", "passwd":"\(password)", "select":"\(type)"])).responseString(encoding: NSUTF8StringEncoding, completionHandler:{ (_, _, string, _) in
            // 测试            
            //println(string)
            }).response { (_, _, _, error) -> Void in
            var mycookie = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
            var cookie:NSHTTPCookie!
            if error != nil {
                println("登录请求错误")
                HUD.hide(true)
            }else{
                //储存cookies
                var mycookie = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
                var cookie:NSHTTPCookie!
                for cookie in mycookie as! [NSHTTPCookie]{
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(cookie.name, forKey: "Cookie_name")
                defaults.setObject(cookie.value, forKey: "Cookie_value")
                defaults.synchronize()
                //println(cookie.value)
                println("cookie存储成功")
                HUD.hide(true)
                self.dismissViewControllerAnimated(true, completion: nil)

                
                }
            }
        }

    }
    
    
    
    
    
//MARK:- life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

