//
//  AppDelegate.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarVC()
        window?.makeKeyAndVisible()
        return true
    }

}

