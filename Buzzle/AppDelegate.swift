//
//  AppDelegate.swift
//  CallOfInfo
//
//  Created by Alpay Kücük on 28.04.20.
//  Copyright © 2020 Alpay Kücük. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import GoogleMobileAds
import AZDialogView



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var modelData: ModelData?
    
    static var counter = 1
    static var instanceIDToken = ""

    
    static var sperre = false
    
    let fbhandler = FBHandler()
    var dialog : AZDialogViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure()
        
        let pushManager = NotificationManager()
        pushManager.registerForPushNotifications()
        
        let defaults = UserDefaults.standard
        let loggedin = defaults.bool(forKey: "LoggedIn")
        let eula = defaults.bool(forKey: "eula")
        let token = defaults.string(forKey: "token")
        if loggedin == nil {
            defaults.set(false, forKey: "LoggedIn")
        }
        if eula == nil {
            defaults.set(false, forKey: "eula")
        }
        
        if token == nil {
            defaults.set(AppDelegate.instanceIDToken, forKey: "token")
        }
        
        //AppDelegate.getCommunityBilderVonDB(id: "1")
        IQKeyboardManager.shared.enable = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      var readableToken: String = ""
      for i in 0..<deviceToken.count {
        readableToken += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
      }
      print("Received an APNs device token: \(readableToken)")
    }
    
    func application(_ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Oh no! Failed to register for remote notifications with error \(error)")
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

             let dataDict:[String: String] = ["token": fcmToken]
             NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

    }
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Test: \(response.notification.request.identifier)")
        completionHandler()
    }
    
    static func getUserFromDefaults() -> Player {
        
        let defaults = UserDefaults.standard
        let id = defaults.string(forKey: "id")
        let username = defaults.string(forKey: "username")
        let password = defaults.string(forKey: "password")
        let level = defaults.integer(forKey: "level")
        let profilbildurl = defaults.string(forKey: "profilbildurl")
        let psn = defaults.string(forKey: "psn")
        let xbox = defaults.string(forKey: "xbox")
        let pc = defaults.string(forKey: "pc")
        let token = defaults.string(forKey: "token")
        let foundUser = Player(id: id!, username: username!, password: password!, level: level, profilbildurl: profilbildurl!, psn: psn!, xbox: xbox!, pc: pc!, token: token!)
        return foundUser
        
    }
    
    
    
}

