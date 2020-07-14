//
//  PushNotificationManeger.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 30/05/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

public class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String?
    var coordinator: AppCoordinator?
    static var flag = true
    init(userID: String?,coordinator: AppCoordinator?) {
        self.userID = userID
        self.coordinator = coordinator
        super.init()
    }
    static var token: String?

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
        
        updateFirestorePushTokenIfNeeded()
    }
    
    func unregisterNotification(){
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken, let id = userID {
            let usersRef = Firestore.firestore().collection("Users").document(id)
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }

    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
             PushNotificationManager.token  = result.token
          }
        }
       
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.categoryIdentifier
         coordinator?.showViewPostInDetails(postID: userInfo)
//

    }
}

