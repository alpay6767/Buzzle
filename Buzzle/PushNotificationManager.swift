//
//  PushNotificationManager.swift
//  Alpo

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class NotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
    }

    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData) // or do whatever
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registration Token: " + fcmToken)
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
    
    func updateFBToken(user: Player) {
        if let token = Messaging.messaging().fcmToken {

            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("User").child(user.id!).child("token").setValue(token)
            
            AppDelegate.instanceIDToken = token
            //let usersRef = Firestore.firestore().collection("users_table").document(userID)
            //usersRef.setData(["fcmToken": token], merge: true)
        }
    }
}
