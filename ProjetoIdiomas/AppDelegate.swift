//
//  AppDelegate.swift
//  ProjetoIdiomas
//
//  Created by Rangel Cardoso Dias on 13/04/20.
//  Copyright © 2020 Rangel Cardoso Dias. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let NOTIFICATION_URL = ""
    static var rootNC: UITabBarController!
    static var sharedCoordinator: AppCoordinator?
    var appCoordinator: AppCoordinator!
//    var notificationUserInfo
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
    
//        let windowScene:UIWindowScene = application.s as! UIWindowScene;
//        let window = UIWindow(windowScene: windowScene)
        //self.window =  UIWindow(frame: UIScreen.main.bounds)
        let tab = UITabBarController()
        
         tab.hidesBottomBarWhenPushed = false
        AppDelegate.rootNC = tab// UINavigationController(rootViewController: tab)//UINavigationController(rootViewController: xib)
        AppDelegate.rootNC.hidesBottomBarWhenPushed = false
//        AppDelegate.rootNC.isNavigationBarHidden = true
    
//        let navigationController = UINavigationController()
           // Initialise the first coordinator with the main navigation controller
        appCoordinator = AppCoordinator(tabBarController: tab)
        AppDelegate.sharedCoordinator = appCoordinator
           // The start method will actually display the main view
        
       
//        window?.makeKeyAndVisible()
//        if #available(iOS 10.0, *){
//            UNUserNotificationCenter.current().delegate = self
//
//            //Peço autorização para notificação
//            let options: UNAuthorizationOptions = [.alert,.badge,.sound]
//            UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: {bool , error in
//
//            })
//        }else{
//            let settings: UIUserNotificationSettings =  UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
        

        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser?.uid, coordinator: AppDelegate.sharedCoordinator)
//        pushManager.registerForPushNotifications()
        appCoordinator.pushNotificationManeger = pushManager
        appCoordinator.start()
//        if let notificationOption = launchOptions?[.remoteNotification]{
//            if let notification = notificationOption as? [String: AnyObject],
//              let aps = notification["userInfo"] as? [AnyHashable: Any] {
//
//              // 2if
//                if let id = aps["category"] as? String{
////                    PushNotificationManager.flag = false
//                   // appCoordinator.start()
////                    appCoordinator.showViewPostInDetails(postID: id)
//                }
//
//
//            }
//        }else{
//            if  PushNotificationManager.flag{
////                let controller = appCoordinator.showFeed()
////                let controoler2 = appCoordinator.showCreatePost()
////                controller!.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)
////                controller!.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
////                let controllers = [controller!, controoler2].map { (viewController) -> UINavigationController in
////                    UINavigationController(rootViewController: viewController)
////                       }
////
////                navigationController.viewControllers = [controller!, controoler2]
////                tab.navigationController
////                tab.viewControllers = [controller!, controoler2]//controllers
////                appCoordinator.start()
//            }
//
//
//        }
        UIApplication.shared.applicationIconBadgeNumber = 0

        
        
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        if let id = userInfo["category"] as? String{
//            PushNotificationManager.flag = false
//           // appCoordinator.start()
//            appCoordinator.showViewPostInDetails(postID: id)
//        }
        
//        if let aps = userInfo["userInfo"] as? [AnyHashable: Any] {
//
//            // 2if
//            if let id = aps["category"] as? String{
//                PushNotificationManager.flag = false
//                // appCoordinator.start()
//                appCoordinator.showViewPostInDetails(postID: id)
//            }
//
//
//        }else{
//            appCoordinator.start()
//        }
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

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        //guard let newToken = InstanceID.instanceID().t else {return}
        print("Firebase registration token: \(fcmToken)")
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        InstanceID.instanceID().instanceID { (tokenID, error) in
            if error != nil {
                print("error no token")
            }else{
//                AppDelegate.DEVICE_ID = tokenID!.instanceID
//                print("O token do Devie é \(AppDelegate.DEVICE_ID )")

                self.connectToFCN()
            }
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let response = response.notification.request.content.userInfo
       
          if let aps = response["userInfo"] as? [AnyHashable: Any] {
          
          // 2if
            if let id = aps["category"] as? String{
                PushNotificationManager.flag = false
               // appCoordinator.start()
                appCoordinator.showViewPostInDetails(postID: id)
            }
          
          
        }

    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //o device id pego o device id do dispostivo
        InstanceID.instanceID().instanceID { (tokenID, error) in
            if error != nil {
                print("error no token")
            }else{
//                AppDelegate.DEVICE_ID = tokenID!.instanceID
//                print("O token do Devie é \(AppDelegate.DEVICE_ID )")
//                self.connectToFCN()
            }
        }
    }
    
    func connectToFCN(){
    }
}
