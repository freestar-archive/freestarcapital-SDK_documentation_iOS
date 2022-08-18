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
//    static let FREESTAR_API_KEY = "5fee93b8-d3d5-43ce-84a5-bffc90e81b5b"
    static let FREESTAR_API_KEY = "XqjhRR"
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
                
        Freestar.setLoggingEnabled(true)
        Freestar.setTestModeEnabled(true)
        Freestar.setAdaptiveBannerEnabledIfAvailable(false)
        Freestar.initWithAppKey(AppDelegate.FREESTAR_API_KEY)
        
        Freestar.requestAppOpenAds(withPlacement: "interstitial_p1", waitScreen: true) { placement, event, error in
            guard let error = error else {
                print(event)
                return
            }
            print("\(error)")
        }
                
        return true
    }
}
