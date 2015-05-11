//
//  LoginView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/20.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
登陆view的实现方式，里面通过输入用户名密码和其他配置，通过Alamofire请求数据

———————————————————————————————————————*/
import UIKit
import Alamofire
import MBProgressHUD
import CoreData

class LoginView: UIViewController
{
    
    @IBOutlet weak var libbgimg: UIImageView!
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
    
    //coreDataStack实例
    var coreDataStack: CoreDataStack = CoreDataStack()
    //NSManagedObjectContext实例赋值在了savecoredata方法中
    var managedObjectContext: NSManagedObjectContext!

    
//MARK:- 功能按钮实现
    @IBAction func loginButton() {
        
        
        saveUserData() //数据处理
        userLogin(UserName,password: PassWord,type: UserNameType) //网络请求
    }
    func netrequest(){
    
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
            defaults.setObject("auto_login", forKey: "auto_login")

            UserName = defaults.stringForKey("Username")!
            PassWord = defaults.stringForKey("Password")!
            }else { //不记住密码
                UserName = Username.text
                PassWord = Password.text
                 defaults.setObject("", forKey: "auto_login")
                
            }
        }else{
            println("错误的用户名或密码输入")
            //错误提示
            var errorHUD = MBProgressHUD()
            errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
            errorHUD.labelText = "错误的用户名或密码输入"
            self.view.addSubview(errorHUD)
            errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
            errorHUD.mode = MBProgressHUDMode.CustomView
            errorHUD.show(true)
            errorHUD.hide(true, afterDelay: 2)
            //保证不为空值
                    UserName = "888888"
                    PassWord = "888888"
        }
        
        // 设置用户名类型
        if usernameType.selectedSegmentIndex == 0 {
            UserNameType = "cert_no"
        }else if usernameType.selectedSegmentIndex == 1 {
            UserNameType = "bar_no"
        }
        
        defaults.setObject(UserNameType, forKey: "UsernameType")



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
            }).response { (_, _, data, error) -> Void in
            //测试登录情况
            if data != nil {
                var parsedata = data as! NSData
                HUD.hide(true)
                self.parseData(parsedata)
                
            }else {
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "无网络或服务器抽风(｡・`ω´･)"
                self.view.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 2)
                 HUD.hide(true)
               
                }
            if error != nil {
                println("登录请求错误")
                HUD.hide(true)
                
            }
        }
        
       

    }

    
    
    //测试登录情况
    func parseData(data:NSData){
        //解析获取的数据
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        //println("begin parse用户信息!")
        if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='mylib_content']/div[1]") {
            println("用户登录成功！！！")
            //成功提示
            var succeedHUD = MBProgressHUD()
            succeedHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
            succeedHUD.labelText = "用户登录成功！"
            succeedHUD.customView = UIImageView(image: UIImage(named: "Checkmark"))
            succeedHUD.mode = MBProgressHUDMode.CustomView
            self.view.addSubview(succeedHUD)
            succeedHUD.show(true)
            succeedHUD.hide(true, afterDelay: 2)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            //用于删除上一个账号留下的数据
            if self.updataCoreData() {
                println("删除数据")
            }else{"fav数据删除失败"}
            
        }else{
            println("用户登录失败！！！")
            //错误提示
            var errorHUD = MBProgressHUD()
            errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
            errorHUD.labelText = "无网络或服务器抽风(｡・`ω´･)"
            self.view.addSubview(errorHUD)
            errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
            errorHUD.mode = MBProgressHUDMode.CustomView
            errorHUD.show(true)
            errorHUD.hide(true, afterDelay: 2)
           
        }
    }

    
    
    
//MARK:- life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply blurring effect
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        libbgimg.addSubview(blurEffectView)

        }

    
    //MARK:更新
    func updataCoreData() -> Bool{
        //如果coredata中有数据就删掉
        managedObjectContext = coreDataStack.context
        if fetchCoreData("favor_FetchRequest") != nil{
            //从获取favbook中的数据中删除
            if let fetchresults = fetchCoreData("favor_FetchRequest"){
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
        let results = coreDataStack.context.executeFetchRequest(fetchRequest,error: &error) as! [Favorites]?
        if let fetchedResults = results {
            // books = fetchedResults
            return fetchedResults
            //store the fetched results in the venues property you defined earlier
        } else {
            println("curbook数据获取失败：Could not fetch \(error), \(error!.userInfo)")
            return nil
        }
        
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

