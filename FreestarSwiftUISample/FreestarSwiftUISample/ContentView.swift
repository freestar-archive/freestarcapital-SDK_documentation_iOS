//
//  ContentView.swift
//  SPM-Test
//
//  Created by Dean Chang on 8/9/22.
//

import SwiftUI
import FreestarAds

struct ContentView: View {
    let bannerPlacementId: String = "banner_p1"
    let mrecPlacementId: String = "mrec_p1"
    let interstitialPlacementId: String = "interstitial_p2"
    let rewardedPlacementId: String = "reward_p1"
        
    @State var interstitial: CustomInterstitialAd?
    @State var rewarded: CustomRewardedAd?
    @State var showBannerFlag = false
    
    init(appDelegate: AppDelegate) {
       // at this point `didFinishLaunching` is completed
        
     }
    
    var body: some View {
        VStack {
            Button("Load & Show Banner") {
                self.showBannerFlag.toggle()
            }
            if showBannerFlag {
                CustomSwiftUIBanner(placementId: mrecPlacementId,
                                           size: FreestarBannerAdSize.banner300x250)
                .frame(width: 300, height: 250)
            }
            Spacer()
            Button("Load & Show Interstitial") {
                interstitial = CustomInterstitialAd(placementId: interstitialPlacementId)
                interstitial?.load()
            }
            Spacer().frame(height: 20)
            Button("Load & Show Rewarded") {
                rewarded = CustomRewardedAd(placementId: rewardedPlacementId,
                                                rewardName: "Coins",
                                                rewardAmount: 1000)
                rewarded?.load()
            }
            Spacer()
            CustomSwiftUIBanner(placementId: bannerPlacementId,
                                  size: FreestarBannerAdSize.banner320x50)
            .frame(width: 320, height: 50)
        }
    }
}
