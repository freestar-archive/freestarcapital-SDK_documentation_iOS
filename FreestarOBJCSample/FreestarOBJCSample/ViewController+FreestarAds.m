//
//  ViewController+ChocolateAd.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 11/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController+FreestarAds.h"

static FreestarBannerAd *banner = nil;
static FreestarBannerAd *smallBanner = nil;
static FreestarPrerollAd *preroll = nil;

static UIAlertController *rewardAlert = nil;
static UIViewController *fullscreenAdContainer = nil;

static UIView *previousBanner = nil;

@implementation ViewController (FreestarAds)

-(void)loadInterstitialAd {
    [FreestarInterstitialAd selectPartners:chosenPartners];
    [FreestarInterstitialAd loadWithDelegate:self];
}

-(void)showInterstitialAd {
    [FreestarInterstitialAd showFrom:self];
}

-(void)loadRewardAd {
    FreestarReward *rew = [FreestarReward blankReward];
    rew.rewardName = @"Coins";
    rew.rewardAmount = 1000;
    
    [FreestarRewardedAd selectPartners:chosenPartners];
    [FreestarRewardedAd loadWithDelegate:self andReward:rew];
}

-(void)showRewardAd {
    [FreestarRewardedAd showFrom:self];
}

-(void)loadBannerAd {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];
    
    [banner removeFromSuperview];
    banner = nil;
    
    [smallBanner removeFromSuperview];
    smallBanner = nil;
    
    banner = [[FreestarBannerAd alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    banner.delegate = self;
    //banner.refreshInterval = 30;
    CGPoint pos = CGPointMake(inviewAdContainer.center.x, inviewAdContainer.center.y + 10);
    
    banner.center = [self.view convertPoint:pos toView:inviewAdContainer];
    [inviewAdContainer addSubview:banner];
}

-(void)showBannerAd {}

-(void)loadPrerollAd {
    preroll = [[FreestarPrerollAd alloc] init];
    preroll.delegate = self;
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
    
    smallBanner = [[FreestarBannerAd alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    smallBanner.delegate = self;
    
    banner.center = [self.view convertPoint:inviewAdContainer.center toView:inviewAdContainer];
    [inviewAdContainer addSubview:smallBanner];
}

-(void)showSmallBannerAd {
//    adTypeLoadedStates[4] = @NO;
//    [self adjustUIForAdState];
//    [smallBanner showIn:inviewAdContainer at:[self.view convertPoint:inviewAdContainer.center toView:inviewAdContainer]];
}

#pragma mark - FreestarInterstitialDelegate

-(void)freestarInterstitialLoaded:(NSString *)winningPartner {
    adTypeLoadedStates[0] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarInterstitialFailed:(FreestarNoAdReason)reason {
    adTypeLoadedStates[0] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarInterstitialShown {
    
}

-(void)freestarInterstitialClicked {
    
}

-(void)freestarInterstitialClosed {
    adTypeLoadedStates[0] = @NO;
    [self adjustUIForAdState];

}

#pragma mark - FreestarRewardedDelegate

-(void)freestarRewardedLoaded:(NSString *)winningPartner {
    adTypeLoadedStates[1] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarRewardedFailed:(FreestarNoAdReason)reason {
    adTypeLoadedStates[1] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarRewardedShown {
    
}

-(void)freestarRewardedClosed {
    adTypeLoadedStates[1] = @NO;
    [self adjustUIForAdState];
    if(rewardAlert) {
        [self presentViewController:rewardAlert animated:YES completion:nil];
    }
}

-(void)freestarRewardedFailedToStart:(FreestarNoAdReason)reason {
    
}

-(void)freestarRewardedReceived:(NSString *)rewardName amount:(NSInteger)rewardAmount {
    rewardAlert = [UIAlertController alertControllerWithTitle:@"Reward Ad Done!" message:[NSString stringWithFormat:@"You've received %ld %@!", rewardAmount, rewardName] preferredStyle:UIAlertControllerStyleAlert];
    [rewardAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        rewardAlert = nil;
    }]];
}

# pragma mark - FreestarBannerAdDelegate

-(void)freestarBannerLoaded:(FreestarBannerAd *)ad {
    adTypeLoadedStates[ad == banner ? 2 : 4] = @YES;
    [self adjustUIForAdState];
}

-(void)freestarBannerFailed:(FreestarBannerAd *)ad because:(FreestarNoAdReason)reason {
    adTypeLoadedStates[ad == banner ? 2 : 4] = @NO;
    [self adjustUIForAdState];
}

-(void)freestarBannerShown:(FreestarBannerAd *)ad {
    
}

-(void)freestarBannerClicked:(FreestarBannerAd *)ad {
    
}

-(void)freestarBannerClosed:(FreestarBannerAd *)ad {
    
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

-(void)freestarPrerollShown:(FreestarPrerollAd *)ad {
    
}

-(void)freestarPrerollClicked:(FreestarPrerollAd *)ad {
    
}

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


@end
