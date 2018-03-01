//
//  AppDelegate.swift
//  星火钱包
//
//  Created by 刘峰 on 2017/11/28.
//  Copyright © 2017年 xeenho. All rights reserved.
//

import UIKit
import Alamofire
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate {
    var window: UIWindow?
    let isProduct = true
    let appKey  =  "93087f7389cf98c3fcd62692"
    let channel = "Publish channel"
    let dog = NetworkReachabilityManager(host: "www.baidu.com")

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dog?.watching()
        
        // 通知注册实体类
        let entity = JPUSHRegisterEntity();
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self);
        // 注册极光推送
        JPUSHService.setup(withOption: launchOptions, appKey: appKey, channel:channel, apsForProduction: isProduct);
        // 获取推送消息
        let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>;
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
            self.perform(#selector(receivePush), with: remote, afterDelay: 1.0);
        }
        
        
        
        return true
    }
    // iOS 10 Support
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        if (notification.request.trigger?.isKind(of: UNNotificationTrigger.self))! {
            let userInfo : NSDictionary = notification.request.content.userInfo as NSDictionary
            JPUSHService .handleRemoteNotification(userInfo as! [AnyHashable : Any])
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        if (response.notification.request.trigger?.isKind(of: UNNotificationTrigger.self))! {
            let userInfo : NSDictionary = response.notification.request.content.userInfo as NSDictionary
            JPUSHService .handleRemoteNotification(userInfo as! [AnyHashable : Any])
        }
        completionHandler()
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
    @objc func receivePush(_ userInfo : Dictionary<String,Any>) {
        // 角标变0
        UIApplication.shared.applicationIconBadgeNumber = 0;
        // 剩下的根据需要自定义
        

    }
    
    

}

