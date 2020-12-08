//
//  Created by Lev Trubov on 11/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController+FreestarAds.h"

static FreestarBannerAd *banner = nil;
static FreestarBannerAd *smallBanner = nil;
static FreestarPrerollAd *preroll = nil;

static FreestarInterstitialAd *interstitial = nil;
static FreestarRewardedAd *rewarded = nil;

static UIAlertController *rewardAlert = nil;
static UIViewController *fullscreenAdContainer = nil;

static UIView *previousBanner = nil;

static FreestarNativeAd *smallNative = nil;
static FreestarNativeAd *mediumNative = nil;

@implementation ViewController (FreestarAds)

-(void)loadInterstitialAd {
    interstitial = [[FreestarInterstitialAd alloc] initWithDelegate:self];
    [interstitial selectPartners:chosenPartners];
    [interstitial loadPlacement:placement.text];
}

-(void)showInterstitialAd {
    [interstitial showFrom:self];
}

-(void)loadRewardAd {
    FreestarReward *rew = [FreestarReward blankReward];
    rew.rewardName = @"Coins";
    rew.rewardAmount = 1000;

    rewarded = [[FreestarRewardedAd alloc] initWithDelegate:self andReward:rew];
    [rewarded selectPartners:chosenPartners];
    [rewarded loadPlacement: placement.text];
}

-(void)showRewardAd {
    [rewarded showFrom:self];
}

-(void)loadBannerAd {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];

    [banner removeFromSuperview];
    banner = nil;

    [smallBanner removeFromSuperview];
    smallBanner = nil;

    banner = [[FreestarBannerAd alloc] initWithDelegate:self andSize:FreestarBanner300x250];
    [banner loadPlacement:placement.text];
}

-(void)showBannerAd {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];

    CGPoint pos = CGPointMake(CGRectGetMidX(inviewAdContainer.bounds), CGRectGetMidY(inviewAdContainer.bounds) + 10);
    banner.center = pos;
    [inviewAdContainer addSubview:banner];
}

-(void)loadPrerollAd {
    preroll = [[FreestarPrerollAd alloc] initWithDelegate:self];
    [preroll addCustomTargeting:@"interests" as:@"sports"];
    preroll.size = FreestarPrerollMREC;
    [preroll loadPlacement:placement.text];
}

-(void)showPrerollAd {
    adTypeLoadedStates[3] = @NO;
    [self adjustUIForAdState];
    [publisherVideo.player pause];
    if(prerollFullscreenToggle.on) {
        fullscreenAdContainer = [[UIViewController alloc] init];
        fullscreenAdContainer.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:fullscreenAdContainer animated:YES completion:^{
            [preroll playIn:fullscreenAdContainer.view at:fullscreenAdContainer.view.center];
        }];
    } else {
        [preroll playOver:publisherVideo];
    }
}

-(void)loadSmallBannerAd {
    adTypeLoadedStates[4] = @NO;
    [self adjustUIForAdState];

    [banner removeFromSuperview];
    banner = nil;

    [smallBanner removeFromSuperview];
    smallBanner = nil;

    smallBanner = [[FreestarBannerAd alloc] initWithDelegate:self andSize:FreestarBanner320x50];
    [smallBanner loadPlacement:placement.text];
}

-(void)showSmallBannerAd {
    adTypeLoadedStates[4] = @NO;
    [self adjustUIForAdState];

    CGPoint pos = CGPointMake(CGRectGetMidX(inviewAdContainer.bounds), CGRectGetMidY(inviewAdContainer.bounds) + 10);
    smallBanner.center = pos;
    [inviewAdContainer addSubview:smallBanner];
}

-(void)loadMediumNativeAd {
    adTypeLoadedStates[5] = @NO;
    [self adjustUIForAdState];

    [mediumNative removeFromSuperview];
    mediumNative = nil;

    [smallNative removeFromSuperview];
    mediumNative = nil;

    mediumNative = [[FreestarNativeAd alloc] initWithDelegate:self andSize:FreestarNativeMedium];
    [mediumNative loadPlacement:placement.text];
}

-(void)showMediumNativeAd {
    adTypeLoadedStates[5] = @NO;
    [self adjustUIForAdState];

    CGPoint pos = CGPointMake(CGRectGetMidX(inviewAdContainer.bounds), CGRectGetMidY(inviewAdContainer.bounds) + 10);
    mediumNative.center = pos;
    [inviewAdContainer addSubview:mediumNative];
}

-(void)loadSmallNativeAd {
    adTypeLoadedStates[6] = @NO;
    [self adjustUIForAdState];

    [mediumNative removeFromSuperview];
    mediumNative = nil;

    [smallNative removeFromSuperview];
    mediumNative = nil;

    smallNative = [[FreestarNativeAd alloc] initWithDelegate:self andSize:FreestarNativeSmall];
    [smallNative loadPlacement:placement.text];
}

-(void)showSmallNativeAd {
    adTypeLoadedStates[6] = @NO;
    [self adjustUIForAdState];

    CGPoint pos = CGPointMake(CGRectGetMidX(inviewAdContainer.bounds), CGRectGetMidY(inviewAdContainer.bounds) + 10);
    smallNative.center = pos;
    [inviewAdContainer addSubview:smallNative];
}

#pragma mark - FreestarInterstitialDelegate

-(void)freestarInterstitialLoaded:(FreestarInterstitialAd *)ad {
    adTypeLoadedStates[0] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarInterstitialFailed:(FreestarInterstitialAd *)ad because:(FreestarNoAdReason)reason {
    adTypeLoadedStates[0] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarInterstitialShown:(FreestarRewardedAd *)ad {

}

-(void)freestarInterstitialClicked:(FreestarRewardedAd *)ad {

}

-(void)freestarInterstitialClosed:(FreestarRewardedAd *)ad {
    adTypeLoadedStates[0] = @NO;
    [self adjustUIForAdState];

}

#pragma mark - FreestarRewardedDelegate

-(void)freestarRewardedLoaded:(FreestarRewardedAd *)ad {
    adTypeLoadedStates[1] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarRewardedFailed:(FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {
    adTypeLoadedStates[1] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarRewardedShown:(FreestarRewardedAd *)ad {

}

-(void)freestarRewardedClosed:(FreestarRewardedAd *)ad {
    adTypeLoadedStates[1] = @NO;
    [self adjustUIForAdState];
    if(rewardAlert) {
        [self presentViewController:rewardAlert animated:YES completion:nil];
    }
}

-(void)freestarRewardedFailedToStart:(FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {

}

-(void)freestarRewardedAd:(FreestarRewardedAd *)ad received:(NSString *)rewardName amount:(NSInteger)rewardAmount {
    rewardAlert = [UIAlertController alertControllerWithTitle:@"Reward Ad Done!" message:[NSString stringWithFormat:@"You've received %ld %@!", rewardAmount, rewardName] preferredStyle:UIAlertControllerStyleAlert];
    [rewardAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        rewardAlert = nil;
    }]];
}

# pragma mark - FreestarBannerAdDelegate

-(void)freestarBannerLoaded:(FreestarBannerAd *)ad {
    NSLog(@"%@ banner loaded", ad == banner ? @"large" : @"small");
    adTypeLoadedStates[ad == banner ? 2 : 4] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarBannerFailed:(FreestarBannerAd *)ad because:(FreestarNoAdReason)reason {
    NSLog(@"%@ banner failed", ad == banner ? @"large" : @"small");
    adTypeLoadedStates[ad == banner ? 2 : 4] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarBannerShown:(FreestarBannerAd *)ad {}
-(void)freestarBannerClicked:(FreestarBannerAd *)ad {}

-(void)freestarBannerClosed:(FreestarBannerAd *)ad {
    NSLog(@"%@ banner closed", ad == banner ? @"large" : @"small");
    adTypeLoadedStates[ad == banner ? 2 : 4] = @NO;
    [self adjustUIForAdState];
}

#pragma mark - FreestarPrerollAdDelegate

-(void)freestarPrerollLoaded:(FreestarPrerollAd *)ad {
    adTypeLoadedStates[3] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarPrerollFailed:(FreestarPrerollAd *)ad because:(FreestarNoAdReason)reason {
    adTypeLoadedStates[3] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarPrerollShown:(FreestarPrerollAd *)ad {}
-(void)freestarPrerollClicked:(FreestarPrerollAd *)ad {}

-(void)freestarPrerollClosed:(FreestarPrerollAd *)ad {
    adTypeLoadedStates[3] = @NO;
    [self adjustUIForAdState];
    if(fullscreenAdContainer) {
        [fullscreenAdContainer dismissViewControllerAnimated:YES completion:^{
            [self->publisherVideo.player play];
            fullscreenAdContainer = nil;
        }];
    } else {
        [publisherVideo.player play];
    }
}
-(void)freestarPrerollFailedToStart:(FreestarPrerollAd *)ad because:(FreestarNoAdReason)reason {
    [publisherVideo.player play];
}

-(void)bannerViewHidden:(BOOL)hidden {
    if(hidden) {
        if(banner.superview) {
            previousBanner = banner;
            [banner removeFromSuperview];
        } else if (smallBanner.superview) {
            previousBanner = smallBanner;
            [smallBanner removeFromSuperview];
        }else if (mediumNative.superview) {
            previousBanner = mediumNative;
            [mediumNative removeFromSuperview];
        }else if (smallNative.superview) {
            previousBanner = smallNative;
            [smallNative removeFromSuperview];
        } else {
            previousBanner = nil;
        }
    } else {
        if(previousBanner) {
            [inviewAdContainer addSubview:previousBanner];
            previousBanner = nil;
        }
    }
}

#pragma mark - FreestarNativeAdDelegate

-(void)freestarNativeLoaded:(FreestarNativeAd *)ad {
    NSLog(@"%@ native loaded", ad == mediumNative ? @"medium" : @"small");
    adTypeLoadedStates[ad == mediumNative ? 5 : 6] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarNativeFailed:(FreestarNativeAd *)ad because:(FreestarNoAdReason)reason {
    NSLog(@"%@ native failed", ad == mediumNative ? @"medium" : @"small");
    adTypeLoadedStates[ad == mediumNative ? 5 : 6] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarNativeShown:(FreestarNativeAd *)ad {}
-(void)freestarNativeClicked:(FreestarNativeAd *)ad {}

-(void)freestarNativeClosed:(FreestarNativeAd *)ad {
    NSLog(@"%@ native closed", ad == mediumNative ? @"medium" : @"small");
    adTypeLoadedStates[ad == mediumNative ? 5 : 6] = @NO;
    [self adjustUIForAdState];
}

@end
