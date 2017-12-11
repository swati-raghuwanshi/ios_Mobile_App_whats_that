//
//  AppDelegate.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/4/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Twitter.sharedInstance().start(withConsumerKey:"jkqXTVDUF27vAFl6QZGmDinnY",consumerSecret:"KQrgJgahJ6GkaumInv5Kf17TszrtDZ9D0UyZdy5CCgB1TMjUWQ")
        return true
    }
    
}

