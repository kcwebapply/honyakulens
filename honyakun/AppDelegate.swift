//
//  AppDelegate.swift
//  honyakun
//
//  Created by WKC on 2016/09/03.
//  Copyright © 2016年 WKC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
     //   var cont = instantiate(topViewController.self,storyboard:"topViewController")
        let cont = instantiate(newTopViewController.self,storyboard:"newTopController")
        let navCon =  UINavigationController(rootViewController: cont)
      // navCon.navigationBar.backgroundColor = UIColorFromRGB(0xFFFFE0)
        navCon.navigationBar.barTintColor = UIColorFromRGB(0xFFFFF3)
        navCon.navigationBar.alpha = 1.0
    //navCon.navigationItem.titleView?.tintColor = UIColor.blueColor()
       // navCon.navigationBar.barTintColor = UIColorFromRGB(0xFF7B6B)
       // navCon.navigationBar.translucent = false
        //navCon.navigationBar.alpha = 1.0

       navCon.navigationBar.tintColor = UIColorFromRGB(0xFF5BBE)
        
        /*var titleLabel = UILabel(frame:CGRectZero)
        titleLabel.font = UIFont.systemFontOfSize(CGFloat(12.0))
        titleLabel.textColor = UIColor.redColor()
        navCon.navigationItem.titleView = titleLabel*/

        window?.rootViewController = navCon
                // instantiate(topViewController.self,storyboard:"topViewController")
       // window?.rootViewController?.navigationController?.navigationBar.backgroundColor = UIColorFromRGB(0xF8F8F8)
        //window?.rootViewController?.navigationController?.navigationBar.tit
        // SVProgressHUD.setForegroundColor(UIColor.blackColor())
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }



}

