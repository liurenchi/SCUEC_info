//
//  AppDelegate.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/19.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
        
        
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        //coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        //coreDataStack.saveContext()
    }


}

