//
//  lostShowView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/2.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import PZPullToRefresh
import Alamofire
import MBProgressHUD
class lostShowView: UITableViewController, PZPullToRefreshDelegate
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
     var HUD = MBProgressHUD()
    var refreshHeaderView: PZPullToRefreshView?
    var lostImgData: NSMutableArray = []
    var lostNoteData: NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        

        HUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
        HUD.labelText = "正在获取招领信息···"
        self.tableView.addSubview(HUD)
        HUD.show(true)
        
        var requestUrl = "http://lrc163.lofter.com"
        Alamofire.request(.GET, "\(requestUrl)").response { (_, _, data, error) in
            
            if error != nil {
                println("招领列表请求错误")
                self.HUD.hide(true)
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "招领列表请求错误"
                self.tableView.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 2)
            }else{
                if data != nil {
                    var parsedata = data as! NSData
                    self.parseLostDetail(parsedata)
                }}
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if refreshHeaderView == nil {
            var view = PZPullToRefreshView(frame: CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            view.delegate = self
            self.tableView.addSubview(view)
            refreshHeaderView = view
        }
        

    }
    
    //MARK:- TFHpple解析方法
    func parseLostDetail(data:NSData){
        
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin lostparse!")
        var loop:Int = 1
        for ( loop; loop <= 10; loop++){
            if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//html/body/div[3]/div[\(loop)]/div[2]/div[1]") {
                // 解析的信息存储
               
               lostNoteData.addObject(output.firstChildWithClassName("text").content)
                
                if var imgnote = output.firstChildWithClassName("img"){
                if var url: AnyObject = imgnote.firstChildWithTagName("a").firstChild.attributes["src"]{
                    lostImgData.addObject(url)
                    }}

            }else{
                println("获取招领列表数据出错")
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "招领列表请求出错"
                self.tableView.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 2)
            
            }
        }
         HUD.hide(true)
         self.tableView.reloadData()
    }
    
  
    
    //unwind
    @IBAction func close(segue:UIStoryboardSegue) {
    }
    
    
// MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return lostImgData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LostthingView

        if var imgurl = self.lostImgData[indexPath.row] as? String{
            var url = NSURL(string: imgurl)
            cell.lostimg.sd_setImageWithURL(url)}
        
        cell.lostnote.text = self.lostNoteData[indexPath.row] as? String
        
        return cell
    }
    
    // MARK: - 下拉刷新配置
    // MARK:UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
    }
    
    // MARK:PZPullToRefreshDelegate
    
    func pullToRefreshDidTrigger(view: PZPullToRefreshView) -> () {
        refreshHeaderView?.isLoading = true
       // println("fuck!")
        var requestUrl = "http://lrc163.lofter.com"
        Alamofire.request(.GET, "\(requestUrl)").response { (_, _, data, error) in
            
            if error != nil {
                println("招领列表请求错误")
                //错误提示
                var errorHUD = MBProgressHUD()
                errorHUD.color = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
                errorHUD.labelText = "招领列表请求出错"
                self.tableView.addSubview(errorHUD)
                errorHUD.customView = UIImageView(image: UIImage(named: "errormark"))
                errorHUD.mode = MBProgressHUDMode.CustomView
                errorHUD.show(true)
                errorHUD.hide(true, afterDelay: 2)
            }else{
                if data != nil {
                    var parsedata = data as! NSData
                    self.lostNoteData.removeAllObjects()
                    self.lostImgData.removeAllObjects()
                    self.parseLostDetail(parsedata)
                    
                    
                }}
        }

        
        self.refreshHeaderView?.isLoading = false
        self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
        
        
    }
    // Optional method
    
    func pullToRefreshLastUpdated(view: PZPullToRefreshView) -> NSDate {
        return NSDate()
    }


}
