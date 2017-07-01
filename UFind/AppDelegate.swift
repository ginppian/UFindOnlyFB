//
//  AppDelegate.swift
//  UFind
//
//  Created by ginppian on 01/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Firebase
        FIRApp.configure()
        registerForRemoteNotification()

        //Navigation Bar Color de tinta
        UINavigationBar.appearance().tintColor = UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0)
        
        //Tab Bar color de tinta
        UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 136/255, blue: 0.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor.black
        
        //Color navegacion
        UINavigationBar.appearance().barTintColor = UIColor.black
        let textAttributes = [NSForegroundColorAttributeName:UIColor.orange]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
        //Diccionario de sesion
        let result = UserDefaults.standard.value(forKey: "userDataUFind")
        print("result: \(result)")
        
        if result != nil {
            let res = result as! [String:String]
            print("res: \(res)")
            
            let sesion = res["sesion"]
            print("sesion: \(sesion)")
            
            if sesion == "on" {
                
                //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                //let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeStoryBoard") as! HomeViewController
                //self.window?.rootViewController = viewController
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let main = storyboard.instantiateViewController(withIdentifier: "TabBarStoryBoard") as! TabBarViewController
                self.window!.rootViewController = main
                //self.window!.makeKeyAndVisible()
            } else {
            
                FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            }
            
        
        } else {
        
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            
        }

        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()

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
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            print("ios 10")
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            print("else")
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //print(deviceToken)
        let deviceTokenString = deviceToken.hexString()
        print("deviceTokenString: \(deviceTokenString)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //        print("Message ID: \(userInfo["gcm_message_id"]!)")
        //        print(userInfo)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarStoryBoard") as! TabBarViewController
        window?.rootViewController = vc
        
    }

}
extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}

