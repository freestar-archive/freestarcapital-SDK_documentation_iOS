//
//  AppDelegate.swift
//  SPM-Test
//
//  Created by Dean Chang on 8/10/22.
//

import Foundation
import UIKit
import FreestarAds

class AppDelegate: NSObject, UIApplicationDelegate {
    static let FREESTAR_API_KEY = "37f63777-6e63-42f2-89b7-4b67689c2493"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Freestar.setLoggingEnabled(true)
        Freestar.setTestModeEnabled(true)
        Freestar.setAdaptiveBannerEnabledIfAvailable(false)
        //        Freestar.setServingMode(.admobGam)
        Freestar.initWithAppKey(AppDelegate.FREESTAR_API_KEY)
        
        return true
    }
}
