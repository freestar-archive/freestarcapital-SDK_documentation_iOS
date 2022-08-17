//
//  AppDelegate.swift
//  FreestarSwiftSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    static let FREESTAR_API_KEY = "ef05da0e-1c5f-4595-b835-74ecedf048dd"
//    static let FREESTAR_API_KEY = "5fee93b8-d3d5-43ce-84a5-bffc90e81b5b"
//      static let FREESTAR_API_KEY = "37f63777-6e63-42f2-89b7-4b67689c2493"
    static let FREESTAR_API_KEY = "1d10c713-cdc8-4d98-9747-1a0724904080"
//    static let FREESTAR_API_KEY = "XqjhRR"
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Freestar.setLoggingEnabled(true)
        Freestar.setTestModeEnabled(true)
        Freestar.setAdaptiveBannerEnabledIfAvailable(true)
//        Freestar.setServingMode(.admobGam)
        Freestar.initWithAppKey(AppDelegate.FREESTAR_API_KEY)
        Freestar.setUserID("User123")

        let tabVC = UITabBarController()

        let thumbVC = ThumbnailAdViewController()
        thumbVC.title = "Thumbnail"

        let fsVC = FullscreenAdViewController()
        fsVC.title = "Fullscreen"
        
        let bVC = BannerAdViewController()
        bVC.title = "Banner"
        
        let pVC = PrerollAdViewController()
        pVC.title = "Preroll"
        
        let feedVC = FeedAdViewController()
        feedVC.title = "Feed"
        
        let nativeVC =  NativeAdViewController()
        nativeVC.title = "Native"
        
        tabVC.viewControllers = [
            UINavigationController(rootViewController: thumbVC),
            UINavigationController(rootViewController: fsVC),
            UINavigationController(rootViewController: bVC),
            UINavigationController(rootViewController: pVC),
            UINavigationController(rootViewController: feedVC),
            UINavigationController(rootViewController: nativeVC)
        ]
        
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.rootViewController = tabVC
        
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
