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

class LibraryView: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    var is_login:Bool = false
    var login:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 62/255, green: 165/255, blue: 64/255, alpha: 1)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.revealViewController().rearViewRevealWidth = 240
        
    }

    
   
   
    
    



}
