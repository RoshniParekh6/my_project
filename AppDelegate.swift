//
//  AppDelegate.swift
//  Parents
//
//  Created by Vikas Prajapati on 15/03/19.
//  Copyright © 2019 Vikas Prajapati. All rights reserved.
//

///added by me

import UIKit
import Reachability
import UserNotifications
import SideMenuSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerNotification()
        utill.prepareApplication(launchOptions: launchOptions)
        return true
    }
    
    func registerNotification(){
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
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
        
        if let _ =  user, let controller = self.window?.visibleViewController as? SideMenuController{
            
            if let settingNavController = controller.contentViewController as? UINavigationController, settingNavController.viewControllers.count == 1, let setting = settingNavController.viewControllers.first as? SettingsViewController {
               
                setting.getCurrentNotificationStatus { (isEnable) in
                    
                    if let userObj = user{
                        userObj.isNotificationEnable = isEnable
                        userObj.sync()
                    }
                    DispatchQueue.main.async {
                        setting.settingsTableView.reloadData()
                    }
                }
                
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate:UNUserNotificationCenterDelegate{
    
    // called when notification is foreground mode
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userNotificationCenter willPresent notification")
        let userInfo = notification.request.content.userInfo
        print("userInfo: \(userInfo.json())")
        
        completionHandler([.alert,.sound])
        
    }
    
    // called when click on notification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("userNotificationCenter didReceive response")
        let userInfo = response.notification.request.content.userInfo
        print("userInfo: \(userInfo.json())")
    }
    
    // called when notification arrived
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotification")
        print("userInfo: \(userInfo.json())")
        
    }
    
    
}
