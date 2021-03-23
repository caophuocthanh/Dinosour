//
//  AppDelegate.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 8/31/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window    = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window = window
        let nv = UINavigationController(rootViewController: RootViewController())
        self.window?.rootViewController = nv
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

