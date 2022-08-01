//
//  AppDelegate.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = UINavigationController(rootViewController:  ViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        ImageLoader.readToCacheFromFilesystem()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // I think it's a bad approach to write file each time the app goes to background,
        // but suitable for a test task (?)
        ImageLoader.saveCacheToFilesystem()
    }
}

