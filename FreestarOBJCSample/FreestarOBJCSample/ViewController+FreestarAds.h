//
//  Created by Lev Trubov on 11/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
@import FreestarAds;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController (FreestarAds) <FreestarInterstitialDelegate, FreestarRewardedDelegate, FreestarBannerAdDelegate, FreestarPrerollAdDelegate>

-(void)loadInterstitialAd;
-(void)showInterstitialAd;
-(void)loadRewardAd;
-(void)showRewardAd;
-(void)loadBannerAd;
-(void)showBannerAd;
-(void)loadSmallBannerAd;
-(void)showSmallBannerAd;
-(void)loadPrerollAd;
-(void)showPrerollAd;

-(void)bannerViewHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
