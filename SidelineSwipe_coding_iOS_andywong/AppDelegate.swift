//
//  AppDelegate.swift
//  SidelineSwipe_coding_iOS_andywong
//
//  Created by Andy Wong on 8/25/20.
//  Copyright © 2020 Andy Wong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ViewController()
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        
        return true
    }
}

