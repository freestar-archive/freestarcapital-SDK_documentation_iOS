//
//  FreestarUnityAdListener.h
//  Unity-iPhone
//
//  Created by Lev Trubov on 9/22/20.
//

#import <Foundation/Foundation.h>
#import <FreestarAds/FreestarAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface FreestarUnityAdListener : NSObject
-(instancetype)initWithUnityListenerName:(NSString *)uln;
@end

@interface FreestarUnityInterstitialAdListener : FreestarUnityAdListener <FreestarInterstitialDelegate>
@property FreestarInterstitialAd *ad;
@end

@interface FreestarUnityRewardAdListener : FreestarUnityAdListener <FreestarRewardedDelegate>
@property FreestarRewardedAd *ad;
@end

@interface FreestarUnityBannerAdListener : FreestarUnityAdListener <FreestarBannerAdDelegate>
@property int adPosition;
@property FreestarBannerAd *ad;
@property BOOL isShowing;
@end

NS_ASSUME_NONNULL_END
