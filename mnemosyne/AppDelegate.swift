//
//  AppDelegate.swift
//  mnemosyne
//
//  Created by Mon on 25/05/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabVC = UITabBarController()
        
        func buildNavigationController(embeded viewController: UIViewController) -> UINavigationController {
            let nc = UINavigationController(rootViewController: viewController)
            if #available(iOS 11.0, *) {
                nc.navigationBar.prefersLargeTitles = true
            }
            
            return nc
        }
        
        // 生成各个控制器
        let clipVC = ClipViewController()
        clipVC.tabBarItem = ClipViewController.myTabbarItem()
        let clipNC = buildNavigationController(embeded: clipVC)
        
        let soundVC = SoundViewController()
        soundVC.tabBarItem = SoundViewController.myTabbarItem()
        let soundNC = buildNavigationController(embeded: soundVC)
        
        let picVC = PicViewController()
        picVC.tabBarItem = PicViewController.myTabbarItem()
        let picNC = buildNavigationController(embeded: picVC)
        
        let settingVC = SettingViewController()
        settingVC.tabBarItem = SettingViewController.myTabbarItem()
        let settingNC = buildNavigationController(embeded: settingVC)
        
        tabVC.viewControllers = [clipNC, soundNC, picNC, settingNC]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabVC
        window?.makeKeyAndVisible()
        
        /// 生成各个文件夹
        createAssetFolders()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

