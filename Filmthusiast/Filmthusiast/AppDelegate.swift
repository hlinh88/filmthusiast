//
//  AppDelegate.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 24/3/2024.
//

import UIKit
import CoreData
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var loadingView: LoadingVC?
    var isShowingSVProgressHUD = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarVC()
        window?.makeKeyAndVisible()
        
        loadingView = LoadingVC()
        if let win = window {
            loadingView!.view.frame = win.bounds
        }
        loadingView!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return true
    }

    func showHUD() {
        guard !isShowingSVProgressHUD else { return }
        
        self.window?.endEditing(true)
        window?.addSubview(loadingView!.view)
        // Something we forget to close keyboard when call API, so this code is for re-close keyboard after 0.3 second to make sure we will have any keyboard on loading screen.
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer: Timer) in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        isShowingSVProgressHUD = true
    }
    
    func dismissHUD() {
        guard isShowingSVProgressHUD else { return }
        
        loadingView?.view.removeFromSuperview()
        
        isShowingSVProgressHUD = false
    }

}

extension SVProgressHUD {
    static func show() {
        print("override SVProgressHUD SHOW")
        AppDelegate.shared.showHUD()
    }
    
    static func dismiss() {
        print("override SVProgressHUD DISMISS")
        AppDelegate.shared.dismissHUD()
    }
}


