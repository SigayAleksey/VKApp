//
//  AppDelegate.swift
//  VKApp
//
//  Created by Алексей Сигай on 28.01.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit
import VK_ios_sdk
import Firebase
import WatchConnectivity
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var watchSession: WCSession?
    var backgroundTask: UIBackgroundTaskIdentifier?
    var dispatchGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpdate: Date? {
        get { return UserDefaults.standard.object(forKey: Constant.Key.lastUpdate) as? Date }
        set { UserDefaults.standard.setValue(newValue, forKey: Constant.Key.lastUpdate) }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //
        FirebaseApp.configure()
        
        // BannerView
        GADMobileAds.configure(withApplicationID: Constant.adMobID)
        
        return true
    }
    
    // VK
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Fetch started time: \(Date())")

        if let lastUpdate = lastUpdate, abs(lastUpdate.timeIntervalSinceNow) < 10 {
            print("Fetch not needed")
            completionHandler(.noData)
            return
        }

        // Действия
        var requestFriendshipCount = 0
        self.dispatchGroup.enter()
        GetRequestFriendship.get() { requestCount in
            requestFriendshipCount = requestCount
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber = requestFriendshipCount
                application.registerForRemoteNotifications()
                print("RequestFriendshipCount: \(requestFriendshipCount)")
            }
        }
        self.dispatchGroup.leave()

        dispatchGroup.notify(queue: .main) {
            self.timer = nil
            self.lastUpdate = Date()
            completionHandler(.newData)
        }

        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(wallDeadline: .now()+29, leeway: .seconds(1))
        timer?.setEventHandler(handler: {
            print("Fetch didn't happen")
            completionHandler(.failed)
        })
        timer?.resume()
    }

}
