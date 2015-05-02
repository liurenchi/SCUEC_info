//
//  newsTableView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/2.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//
/*———————————————————————————————————————
学校新闻列表的获取获取
———————————————————————————————————————*/
import UIKit
import PZPullToRefresh
import Alamofire
import MBProgressHUD
class newsTableView: UITableViewController, PZPullToRefreshDelegate
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var refreshHeaderView: PZPullToRefreshView?
    var newsTableData: NSMutableArray = []
    var newsUrlData: NSMutableArray = []
    var newsTimeData: NSMutableArray = []
    //进度提示
    var HUD = MBProgressHUD()
    
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
        HUD.labelText = "正在获取新闻···"
        self.tableView.addSubview(HUD)
        HUD.show(true)
        
        Alamofire.request(.GET, "http://news.scuec.edu.cn/xww/?class-focusNews.htm").response { (_, _, data, error) in
            
            if error != nil {
                println("新闻信息请求错误")
                self.HUD.hide(true)
            }else{
                if data != nil {
                    var parsedata = data as! NSData
                    self.parseNewsTable(parsedata)
                   
                    
                }}
        }

        
        
        
        
    
    
    
    }
    //MARK:- TFHpple解析方法
    func parseNewsTable(data:NSData){
        
        var doc:TFHpple = TFHpple(HTMLData: data, encoding: "UTF8")
        println("begin newstableparse!")
        var loop:Int = 1
        for ( loop; loop <= 12; loop++){
            if var output:TFHppleElement = doc.peekAtSearchWithXPathQuery("//*[@id='container']/section/section/div[2]/ul/li[\(loop)]") {
                
                
                //数据存入数组
                newsTableData.addObject(output.firstChild.content)
                if var url: AnyObject = output.firstChild.attributes["href"]
                {
                    newsUrlData.addObject(url)
                    
                }
                if var newstime = output.children[1].content{
                    newsTimeData.addObject(newstime)
                }
               

            }else{
                println("获取新闻列表数据出错")}
        }
        HUD.hide(true)
        self.tableView.reloadData()
    }

    
    override func viewWillAppear(animated: Bool) {
        if refreshHeaderView == nil {
            var view = PZPullToRefreshView(frame: CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            view.delegate = self
            self.tableView.addSubview(view)
            refreshHeaderView = view
        }    }



    // MARK: - Table view data source



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return newsTableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! newsTableCell

        cell.newstitle.text = newsTableData[indexPath.row] as? String
        cell.newstime.text = newsTimeData[indexPath.row] as? String

        return cell
    }
// MARK: - 导航
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "shownewdetails" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationController = segue.destinationViewController as! newsDetailView
                destinationController.newsurl = newsUrlData[row] as! String
                destinationController.newstitle = newsTableData[row] as! String

                
            }
        }
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
        println("fuck!")
        Alamofire.request(.GET, "http://news.scuec.edu.cn/xww/?class-focusNews.htm").response { (_, _, data, error) in
            
            if error != nil {
                println("新闻信息请求错误")
                self.refreshHeaderView?.isLoading = false
                self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
            }else{
                if data != nil {
                    var parsedata = data as! NSData
                    self.parseNewsTable(parsedata)
                    self.refreshHeaderView?.isLoading = false
                    self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
                    
                }}
        }
        
        

        
    }
    // Optional method
    
    func pullToRefreshLastUpdated(view: PZPullToRefreshView) -> NSDate {
        return NSDate()
    }
    

}

