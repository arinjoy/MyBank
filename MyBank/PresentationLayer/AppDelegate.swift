//
//  AppDelegate.swift
//  MyBank
//
//  Created by Arinjoy Biswas on 12/9/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        guard let rootVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "AccountDetailsVC") as? AccountDetailsViewController
        else {
            fatalError("`AccountDetailsViewController` could not be constructed out of main storyboard")
        }
        
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        
        window?.makeKeyAndVisible()
        return true
    }
}

