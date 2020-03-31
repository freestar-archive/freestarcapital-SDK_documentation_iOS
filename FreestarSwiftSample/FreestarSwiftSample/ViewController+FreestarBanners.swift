//
//  ViewController+FreestarBanners.swift
//  FreestarSwiftSample
//
//  Created by Vdopia Developer on 3/27/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import Foundation
import FreestarAds

extension ViewController : FreestarBannerAdDelegate {
    
    
    func loadBannerAd() {
        
    }
    
    func loadSmallBannerAd() {
        smallBanner?.removeFromSuperview()
        smallBanner = FreestarBannerAd(delegate: self, andSize: .banner320x50)
        smallBanner?.loadPlacement(nil)
    }
    
    func showBannerAd() {
        
    }
    
    func showSmallBannerAd() {
        loadButton.isEnabled = true
        showButton.isEnabled = false
        smallBanner?.center = CGPoint(x: bannerAdContainer.bounds.midX, y: bannerAdContainer.bounds.midY)
        bannerAdContainer.addSubview(smallBanner!)
    }
    
    // - Banner Delegate
    
    func freestarBannerLoaded(_ ad: FreestarBannerAd) {
        showButton.isEnabled = true
    }
    
    func freestarBannerFailed(_ ad: FreestarBannerAd, because reason: FreestarNoAdReason) {
        
    }
    
    func freestarBannerShown(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClicked(_ ad: FreestarBannerAd) {
        
    }
    
    func freestarBannerClosed(_ ad: FreestarBannerAd) {
        showButton.isEnabled = false
    }
    
}
