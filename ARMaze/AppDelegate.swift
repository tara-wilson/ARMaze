//
//  AppDelegate.swift
//  ARMaze
//
//  Created by Tara Wilson on 9/16/17.
//  Copyright © 2017 taraw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let win = UIWindow()
        win.frame = UIScreen.main.bounds
        
        if let level = getLevel() {
            let nav = UINavigationController(rootViewController: MapViewController())
            nav.navigationBar.isHidden = true
            win.rootViewController = nav
        } else {
            let nav = UINavigationController(rootViewController: StartViewController())
            nav.navigationBar.isHidden = true
            win.rootViewController = nav
        }
        
        window = win
        window?.makeKeyAndVisible()
        
        return true
    }

    func getLevel() -> Level? {
//        if let savedLevel = UserDefaults.standard.string(forKey: "level") {
//            switch savedLevel {
//            case "easy":
//                return .easy
//            case "hard":
//                return .hard
//            default:
//                return nil
//            }
//        }
        return nil
    }


}

