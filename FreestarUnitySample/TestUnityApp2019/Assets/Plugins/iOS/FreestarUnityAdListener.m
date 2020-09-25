//
//  FreestarUnityAdListener.m
//  Unity-iPhone
//
//  Created by Lev Trubov on 9/22/20.
//

#import "FreestarUnityAdListener.h"

@interface FreestarUnityAdListener ()
@property (copy) NSString *unityListenerName;
@end

@implementation FreestarUnityAdListener
-(instancetype)initWithUnityListenerName:(NSString *)uln {
    self = [super init];
    self.unityListenerName = uln;
    return self;
}

-(void)makeUnityCallback:(NSString *)function withMessage:(NSString *)message {
    UnitySendMessage([self.unityListenerName cStringUsingEncoding:NSASCIIStringEncoding],
                     [function cStringUsingEncoding:NSASCIIStringEncoding],
                     [message cStringUsingEncoding:NSASCIIStringEncoding]);
}

@end

@implementation FreestarUnityInterstitialAdListener

- (void)freestarInterstitialClicked:(nonnull FreestarInterstitialAd *)ad {
    [self makeUnityCallback:@"onInterstitialAdClicked" withMessage:ad.placement];
}

- (void)freestarInterstitialClosed:(nonnull FreestarInterstitialAd *)ad {
    [self makeUnityCallback:@"onInterstitialAdDismissed" withMessage:ad.placement];
}

- (void)freestarInterstitialFailed:(nonnull FreestarInterstitialAd *)ad because:(FreestarNoAdReason)reason {
    [self makeUnityCallback:@"onInterstitialAdFailed" withMessage:ad.placement];
}

- (void)freestarInterstitialLoaded:(nonnull FreestarInterstitialAd *)ad {
    [self makeUnityCallback:@"onInterstitialAdLoaded" withMessage:ad.placement];
}

- (void)freestarInterstitialShown:(nonnull FreestarInterstitialAd *)ad {
    [self makeUnityCallback:@"onInterstitialAdShown" withMessage:ad.placement];
}

@end

@implementation FreestarUnityRewardAdListener

- (void)freestarRewardedAd:(nonnull FreestarRewardedAd *)ad received:(nonnull NSString *)rewardName amount:(NSInteger)rewardAmount {
    [self makeUnityCallback:@"onRewardedAdFinished" withMessage:ad.placement];
}

- (void)freestarRewardedClosed:(nonnull FreestarRewardedAd *)ad {
    [self makeUnityCallback:@"onRewardedAdDismissed" withMessage:ad.placement];
}

- (void)freestarRewardedFailed:(nonnull FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {
    [self makeUnityCallback:@"onRewardedAdFailed" withMessage:ad.placement];
}

- (void)freestarRewardedFailedToStart:(nonnull FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {
    [self makeUnityCallback:@"onRewardedAdFailed" withMessage:ad.placement];
}

- (void)freestarRewardedLoaded:(nonnull FreestarRewardedAd *)ad {
    [self makeUnityCallback:@"onRewardedAdLoaded" withMessage:ad.placement];

}

- (void)freestarRewardedShown:(nonnull FreestarRewardedAd *)ad {
    [self makeUnityCallback:@"onRewardedAdShown" withMessage:ad.placement];
}

@end

@implementation FreestarUnityBannerAdListener

-(int)sizeCode:(FreestarBannerAd *)ad {
    if (ad.size == FreestarBanner320x50) {
        return 0;
    } else {
        return 1;
    }
}

- (void)freestarBannerClicked:(nonnull FreestarBannerAd *)ad {
    [self makeUnityCallback:@"BannerAdClicked" withMessage:[NSString stringWithFormat:@"%@,%d", [ad valueForKeyPath:@"ad.placement"], [self sizeCode:ad]]];
}

- (void)freestarBannerClosed:(nonnull FreestarBannerAd *)ad {
    //Unity bridge has no closed callback
    self.isShowing = NO;
}

- (void)freestarBannerFailed:(nonnull FreestarBannerAd *)ad because:(FreestarNoAdReason)reason {
    [self makeUnityCallback:@"BannerAdFailed" withMessage:[NSString stringWithFormat:@"%@,%d", [ad valueForKeyPath:@"ad.placement"], [self sizeCode:ad]]];
}

- (void)freestarBannerLoaded:(nonnull FreestarBannerAd *)ad {
    UIWindow *kw = nil;
    for(UIWindow *w in UIApplication.sharedApplication.windows) {
        if ([w isKeyWindow]) {
            kw = w;
            break;
        }
    }
    
    CGFloat vPos;
    if (self.adPosition == 0) { //bottom
        vPos = kw.bounds.size.height - ad.bounds.size.height/2;
    } else if (self.adPosition == 1) { //middle
        vPos = CGRectGetMidY(kw.bounds);
    } else { //top
        vPos = ad.bounds.size.height/2;
    }
    
    ad.center = CGPointMake(CGRectGetMidX(kw.bounds), vPos);
    [kw addSubview:ad];
    
    self.isShowing = YES;
    [self makeUnityCallback:@"BannerAdShown" withMessage:[NSString stringWithFormat:@"%@,%d", [ad valueForKeyPath:@"ad.placement"], [self sizeCode:ad]]];
}

- (void)freestarBannerShown:(nonnull FreestarBannerAd *)ad {
//    self.isShowing = YES;
//    [self makeUnityCallback:@"onBannerAdShowing" withMessage:[ad valueForKeyPath:@"ad.placement"]];
}

@end
