//
//  AppDelegate.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/12/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let selectedLeagues: [League] = {
        let userDefaults = UserDefaults.standard
        
        guard let leagueIds = userDefaults.array(forKey: "selectedLeagues") as? [Int] else {
            return [
                League.LCS,
                League.LEC,
                League.LCK,
                League.LPL,
                League.LMS,
                League.Worlds,
                League.MSI,
                League.AllStar
            ]
        }
        
        return leagueIds.filter { (current) -> Bool in
            return League.leagues.leagues.contains(where: { $0.id == current })
        }.map({ (current) -> League in
            return League.leagues.leagues.first(where: { $0.id == current })! // Safe beacuse it's already checked by filtering
        })
    }()
    
    private lazy var mainViewController: MainViewController = {
        let lolEsportsService = LolEsportsService()
        
        let leagueCollections = [
            League.regional,
            League.international,
            League.other
        ]
            
        let mainViewController = MainViewController(leagueCollections: leagueCollections,
                                                    selectedLeagues:   self.selectedLeagues,
                                                    lolEsportsService: lolEsportsService)
        mainViewController.view.backgroundColor = UIColor.black
        
        return mainViewController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure firebase before anything else
        FirebaseApp.configure()
        
        // Configure window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.mainViewController
        self.window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print(error)
            }
        }
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        
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

// MARK: App Delegate - User Notification Center (Delegate)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.mainViewController.scheduleViewController.setShouldDisplayFavorites(true)
        self.mainViewController.scheduleViewController.scrollToMatch(Int(response.notification.request.identifier) ?? -1)
        completionHandler()
    }
}
