//
//  AppDelegate.swift
//  drinkApp
//
//  Created by 林祐辰 on 2020/9/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UINavigationBar.appearance().barTintColor = UIColor(red: 1/255, green: 59/255, blue: 79/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(red: 183/255, green: 144/255, blue: 56/255, alpha: 1)
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


}

