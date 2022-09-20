//
//  RewardedAd.swift
//  FreestarSwiftUISample
//
//  Created by Dean Chang on 8/18/22.
//

import Foundation
import FreestarAds

final class CustomRewardedAd: FreestarRewardedDelegate {
    
    var placementId: String?
    var rewardName: String?
    var rewardAmount: Int?
    var rewardedAd: FreestarRewardedAd?
    var rewardAlert : UIAlertController?
    
    init(placementId: String?, rewardName: String?, rewardAmount: Int?) {
        self.placementId = placementId
        self.rewardName = rewardName
        self.rewardAmount = rewardAmount
    }
    
    func load() {
        let rew = FreestarReward.blank()
        guard let rewardName = rewardName, let rewardAmount = rewardAmount else {
            return
        }
        rew.rewardName = rewardName
        rew.rewardAmount = UInt(rewardAmount)
        rewardedAd = FreestarRewardedAd(delegate: self, andReward: rew)
        rewardedAd?.loadPlacement(placementId)
    }
    
    func showAd() {
        guard let rewardedAd = rewardedAd, let viewController = UIApplication.shared.keyWindowPresentedController else {
            return
        }
        rewardedAd.show(from: viewController)
    }
    
// MARK: FreestarRewardedDelegate
    
    func freestarRewardedLoaded(_ ad: FreestarRewardedAd) {
        print("\(#function)")
        showAd()
    }
    
    func freestarRewardedFailed(_ ad: FreestarRewardedAd, because reason: FreestarNoAdReason) {
        print("\(#function)")
    }
    
    func freestarRewardedShown(_ ad: FreestarRewardedAd) {
        print("\(#function)")
    }
    
    func freestarRewardedClosed(_ ad: FreestarRewardedAd) {
        print("\(#function)")
    }
    
    func freestarRewardedFailed(toStart ad: FreestarRewardedAd, because reason: FreestarNoAdReason) {
        print("\(#function)")
    }
    
    func freestarRewardedAd(_ ad: FreestarRewardedAd, received rewardName: String, amount rewardAmount: Int) {
        print("\(#function)")
        rewardAlert = UIAlertController(
            title: "Reward Ad Done!",
            message: "You've received \(rewardAmount) \(rewardName)!",
            preferredStyle: .alert)
        rewardAlert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_ UIAlertAction) in
            self.rewardAlert = nil
        }))
    }
}

