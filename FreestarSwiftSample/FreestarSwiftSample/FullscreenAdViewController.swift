//
//  FullscreenAdViewController.swift
//  FreestarSwiftSample
//
//  Created by Vdopia Developer on 3/30/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

import UIKit
import FreestarAds

class FullscreenAdViewController: AdViewController {
    
    var interstitialAd : FreestarInterstitialAd?
    var rewardedAd : FreestarRewardedAd?
    
    var interstitialAdReady = false {
        didSet {
            updateShowButton()
        }
    }
    
    var rewardedAdReady = false {
        didSet {
            updateShowButton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        concreteAdTypeSelector.addTarget(self,
                                         action: #selector(FullscreenAdViewController.updateShowButton),
                                         for: .valueChanged)
    }
    
    // MARK: - data for common elements

    override func selectedAdType() -> FreestarAdType {
        return concreteAdTypeSelector.selectedSegmentIndex == 0 ? .Interstitial : .Rewarded
    }
    
    override func concreteAdTypes() -> [String] {
        return ["Interstitial", "Rewarded"]
    }
    
    override func loadChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            loadInterstitialAd()
        } else {
            loadRewardedAd()
        }
    }
    
    override func showChosenAd() {
        if concreteAdTypeSelector.selectedSegmentIndex == 0 {
            showInterstitialAd()
        } else {
            showRewardedAd()
        }
    }

    // MARK: - controlling UI
    
    @objc func updateShowButton() {
        showButton.isEnabled =
            (self.concreteAdTypeSelector.selectedSegmentIndex == 0 && interstitialAdReady) ||
            (self.concreteAdTypeSelector.selectedSegmentIndex == 1 && rewardedAdReady)
    }

}

extension FullscreenAdViewController : FreestarInterstitialDelegate {
    func loadInterstitialAd() {
        
    }
    
    func showInterstitialAd() {
        
    }
    
    func freestarInterstitialLoaded(_ ad: FreestarInterstitialAd) {
        self.interstitialAdReady = true
    }
    
    func freestarInterstitialFailed(_ ad: FreestarInterstitialAd, because reason: FreestarNoAdReason) {
        self.interstitialAdReady = false
    }
    
    func freestarInterstitialShown(_ ad: FreestarInterstitialAd) {
        
    }
    
    func freestarInterstitialClicked(_ ad: FreestarInterstitialAd) {
        
    }
    
    func freestarInterstitialClosed(_ ad: FreestarInterstitialAd) {
        
    }
}

extension FullscreenAdViewController : FreestarRewardedDelegate {
    func loadRewardedAd() {
        
    }
    
    func showRewardedAd() {
        
    }
    
    func freestarRewardedLoaded(_ ad: FreestarRewardedAd) {
        
    }
    
    func freestarRewardedFailed(_ ad: FreestarRewardedAd, because reason: FreestarNoAdReason) {
        
    }
    
    func freestarRewardedShown(_ ad: FreestarRewardedAd) {
        
    }
    
    func freestarRewardedClosed(_ ad: FreestarRewardedAd) {
        
    }
    
    func freestarRewardedFailed(toStart ad: FreestarRewardedAd, because reason: FreestarNoAdReason) {
        
    }
    
    func freestarRewardedAd(_ ad: FreestarRewardedAd, received rewardName: String, amount rewardAmount: Int) {
        
    }
    
    
}
