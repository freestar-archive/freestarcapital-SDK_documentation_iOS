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
    
    var rewardAlert : UIAlertController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.enablePartnerSelection = true

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
    
    @objc override func updateShowButton() {
        showButton.isEnabled =
            (self.concreteAdTypeSelector.selectedSegmentIndex == 0 && interstitialAdReady) ||
            (self.concreteAdTypeSelector.selectedSegmentIndex == 1 && rewardedAdReady)
    }
}

extension FullscreenAdViewController : FreestarInterstitialDelegate {
    func loadInterstitialAd() {
        self.interstitialAd = FreestarInterstitialAd(delegate: self)
        self.interstitialAd?.selectPartners(self.chosenPartners)
        self.interstitialAd?.loadPlacement(placementField.text)
    }
    
    func showInterstitialAd() {
        interstitialAd?.show(from: self)
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
        self.interstitialAdReady = false
    }
}

extension FullscreenAdViewController : FreestarRewardedDelegate {
    func loadRewardedAd() {
        let rew = FreestarReward.blank()
        rew.rewardName = "Coins"
        rew.rewardAmount = 1000
        self.rewardedAd = FreestarRewardedAd(delegate: self, andReward: rew)
        self.rewardedAd?.selectPartners(self.chosenPartners)
        self.rewardedAd?.loadPlacement(placementField.text)
    }
    
    func showRewardedAd() {
        rewardedAd?.show(from: self)
    }
    
    func freestarRewardedLoaded(_ ad: FreestarRewardedAd) {
        self.rewardedAdReady = true
    }
    
    func freestarRewardedFailed(_ ad: FreestarRewardedAd, because reason: FreestarNoAdReason) {
        self.rewardedAdReady = false
    }
    
    func freestarRewardedShown(_ ad: FreestarRewardedAd) {
        
    }
    
    func freestarRewardedClosed(_ ad: FreestarRewardedAd) {
        self.rewardedAdReady = false
        
        guard let ra = rewardAlert else { return }
        self.present(ra, animated: true, completion: nil)
    }
    
    func freestarRewardedFailed(toStart ad: FreestarRewardedAd, because reason: FreestarNoAdReason) {
        
    }
    
    func freestarRewardedAd(_ ad: FreestarRewardedAd, received rewardName: String, amount rewardAmount: Int) {
        rewardAlert = UIAlertController(
            title: "Reward Ad Done!",
            message: "You've received \(rewardAmount) \(rewardName)!",
            preferredStyle: .alert)
        rewardAlert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_ UIAlertAction) in
            self.rewardAlert = nil
        }))
    }
}
