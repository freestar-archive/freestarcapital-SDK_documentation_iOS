//
//  CustomInterstitialAd.swift
//  FreestarSwiftUISample
//
//  Created by Dean Chang on 8/18/22.
//

import Foundation
import FreestarAds

final class CustomInterstitialAd: FreestarInterstitialDelegate {
    
    var placementId: String?
    var interstitialAd: FreestarInterstitialAd?
    
    init(placementId: String?) {
        self.placementId = placementId
    }
    
    func load() {
        interstitialAd = FreestarInterstitialAd(delegate: self)        
        interstitialAd?.loadPlacement(placementId)
    }
    
    func showAd() {
        guard let interstitialAd = interstitialAd, let viewController = UIApplication.shared.keyWindowPresentedController else {
            return
        }
        interstitialAd.show(from: viewController)
    }
        
    // MARK: FreestarInterstitialDelegate
        
    func freestarInterstitialLoaded(_ ad: FreestarInterstitialAd) {
        print("\(#function)")
        self.showAd()
    }
    
    func freestarInterstitialFailed(_ ad: FreestarInterstitialAd, because reason: FreestarNoAdReason) {
        print("\(#function)")
    }
    
    func freestarInterstitialShown(_ ad: FreestarInterstitialAd) {
        print("\(#function)")
    }
    
    func freestarInterstitialClosed(_ ad: FreestarInterstitialAd) {
        print("\(#function)")
    }
}

