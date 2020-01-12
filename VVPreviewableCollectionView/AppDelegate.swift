//
//  AppDelegate.swift
//  VVPreviewableCollectionView
//
//  Created by Vivi on 2020/1/12.
//  Copyright © 2020 Vivi Yang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = DemoViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
