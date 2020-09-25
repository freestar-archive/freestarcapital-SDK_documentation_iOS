//
//  VdopiaiOSBridge.m
//
//
//  Created by Sachin Patil on 02/08/17.
//
//

#import "FreestarUnityBridge.h"
#import <FreestarAds/FreestarAds.h>
#import "FreestarUnityAdListener.h"

UIViewController *topViewControllerFrom(UIViewController *rootViewController) {
    if (rootViewController.presentedViewController == nil)  {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return  topViewControllerFrom(lastViewController);
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return topViewControllerFrom(selectedViewController);
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return topViewControllerFrom(presentedViewController);
}

UIViewController *topViewController() {
    return topViewControllerFrom(UIApplication.sharedApplication.keyWindow.rootViewController);
}


static NSString *unityListenerName = nil;
static NSMutableDictionary *interstitialListeners = nil;
static NSMutableDictionary *rewardListeners = nil;
static NSString *bannerListenerName = nil;

static NSMutableDictionary *bannerListeners = nil;


void _initWithAPIKey(char *apiKey) {
    [Freestar initWithAdUnitID:[NSString stringWithCString:apiKey encoding:NSASCIIStringEncoding]];
}

void _setupWithListener(char *listenerName) {
    unityListenerName = [[[NSString stringWithCString:listenerName encoding:NSASCIIStringEncoding] componentsSeparatedByString:@" "] firstObject];
}

void _setBannerListener(char *listenerName) {
    bannerListenerName = [NSString stringWithCString:listenerName encoding:NSASCIIStringEncoding];
}

void _loadInterstitialAd(char *placement) {
    NSString *placementString = [NSString stringWithCString:placement encoding:NSASCIIStringEncoding];
    if (interstitialListeners == nil) {
        interstitialListeners = [[NSMutableDictionary alloc] init];
    }
    
    FreestarUnityInterstitialAdListener *listener = interstitialListeners[placementString];
    if(listener == nil) {
        listener = [[FreestarUnityInterstitialAdListener alloc] initWithUnityListenerName:unityListenerName];
        interstitialListeners[placementString] = listener;
    }
    
    listener.ad = [[FreestarInterstitialAd alloc] initWithDelegate:listener];
    [listener.ad loadPlacement:placementString];
}

void _showInterstitialAd(char *placement) {
    NSString *placementString = [NSString stringWithCString:placement encoding:NSASCIIStringEncoding];
    FreestarUnityInterstitialAdListener *listener = interstitialListeners[placementString];
    [listener.ad showFrom:topViewController()];
}

void _loadRewardedAd(char *placement) {
    NSString *placementString = [NSString stringWithCString:placement encoding:NSASCIIStringEncoding];
    if (rewardListeners == nil) {
        rewardListeners = [[NSMutableDictionary alloc] init];
    }
    
    FreestarUnityRewardAdListener *listener = rewardListeners[placementString];
    if(listener == nil) {
        listener = [[FreestarUnityRewardAdListener alloc] initWithUnityListenerName:unityListenerName];
        rewardListeners[placementString] = listener;
    }
    
    listener.ad = [[FreestarRewardedAd alloc] initWithDelegate:listener andReward:[FreestarReward blankReward]];
    [listener.ad loadPlacement:placementString];
    
}

void _showRewardedAd(char* placement, int rewardAmount,char* rewardName, char* userId, char* secretKey) {
    FreestarReward *rew = [FreestarReward blankReward];
    rew.rewardName = [NSString stringWithCString:rewardName encoding:NSASCIIStringEncoding];
    rew.rewardAmount = rewardAmount;
    rew.userID = [NSString stringWithCString:userId encoding:NSASCIIStringEncoding];
    rew.secretKey = [NSString stringWithCString:secretKey encoding:NSASCIIStringEncoding];
    
    NSString *placementString = [NSString stringWithCString:placement encoding:NSASCIIStringEncoding];
    FreestarUnityRewardAdListener *listener = interstitialListeners[placementString];
    listener.ad.reward = rew;
    [listener.ad showFrom:topViewController()];
}

void _setDemograpics(int age, char* birthDate, char* gender, char* maritalStatus,
                     char* ethnicity) {
    FreestarDemographics *dem = [Freestar demographics];
    dem.age = age;
    
    NSArray<NSString*> *comps = [[NSString stringWithCString:birthDate encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"-"];
    if(comps.count >= 3){
        NSInteger year = [comps[0] integerValue];
        NSInteger month = [comps[1] integerValue];
        NSInteger day = [comps[2] integerValue];
        if(year != 0 && month != 0 && day != 0){
            [dem setBirthdayYear:year month:month day:day];
        }
    }
    
    NSString *msNS = [NSString stringWithCString:maritalStatus encoding:NSASCIIStringEncoding];
    if([msNS rangeOfString:@"single" options:NSCaseInsensitiveSearch].location != NSNotFound){
        dem.maritalStatus = FreestarMaritalStatusSingle;
    }else if([msNS rangeOfString:@"married" options:NSCaseInsensitiveSearch].location != NSNotFound){
        dem.maritalStatus = FreestarMaritalStatusMarried;
    }else if([msNS rangeOfString:@"divorced" options:NSCaseInsensitiveSearch].location != NSNotFound){
        dem.maritalStatus = FreestarMaritalStatusDivorced;
    }else if([msNS rangeOfString:@"widowed" options:NSCaseInsensitiveSearch].location != NSNotFound){
        dem.maritalStatus = FreestarMaritalStatusWidowed;
    }else if([msNS rangeOfString:@"separated" options:NSCaseInsensitiveSearch].location != NSNotFound){
        dem.maritalStatus = FreestarMaritalStatusSeparated;
    }else if([msNS rangeOfString:@"other" options:NSCaseInsensitiveSearch].location != NSNotFound){
        dem.maritalStatus = FreestarMaritalStatusOther;
    }
    
    NSString *genderString = [NSString stringWithCString:gender encoding:NSASCIIStringEncoding];
    
    NSRange maleRange = [genderString rangeOfString:@"Male" options:NSCaseInsensitiveSearch];
    NSRange feMaleRange = [genderString rangeOfString:@"Female" options:NSCaseInsensitiveSearch];
    
    if (maleRange.location != NSNotFound){
        dem.gender = FreestarGenderMale;
    }else if (feMaleRange.location != NSNotFound){
        dem.gender = FreestarGenderFemale;
    }else if (feMaleRange.location != NSNotFound){
        dem.gender = FreestarGenderOther;
    }

    dem.ethnicity = [NSString stringWithCString:ethnicity encoding:NSASCIIStringEncoding];
}

void _setLocation(char* dmaCode, char* postal, char* curPostal, char* latitude, char* longitude) {
    FreestarLocation *loc = [Freestar location];
    
    if(dmaCode){
        loc.dmacode = [NSString stringWithCString:dmaCode encoding:NSASCIIStringEncoding];
    }
    if(postal){
        loc.postalcode = [NSString stringWithCString:postal encoding:NSASCIIStringEncoding];
    }
    if(curPostal){
        loc.currpostal = [NSString stringWithCString:curPostal encoding:NSASCIIStringEncoding];
    }
    
    if(latitude && longitude){
        NSString *latString = [NSString stringWithCString:latitude encoding:NSASCIIStringEncoding];
        NSString *lonString = [NSString stringWithCString:longitude encoding:NSASCIIStringEncoding];
        CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[latString floatValue] longitude:[lonString floatValue]];
    
    
        loc.location = LocationAtual;
    }
    
}

void _setPrivacySettings(_Bool gdprApplies, char* gdprConsentString) {
    NSString *consentString = nil;
    if(gdprConsentString){
        consentString = [NSString stringWithCString:gdprConsentString encoding:NSASCIIStringEncoding];
    }
    
    [[Freestar privacySettings]
     subjectToGDPR:gdprApplies
     withConsent:consentString];
}

#pragma mark - custom segment properties

void _setCustomSegmentProperty(char* key, char* value) {
    NSString *pKey = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    NSString *pVal = [NSString stringWithCString:value encoding:NSASCIIStringEncoding];
    [FreestarCustomSegmentProperties
     setCustomSegmentProperty:pKey with:pVal];
}

const char* _Nullable _getCustomSegmentProperty(char* key) {
    NSString *pKey = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    NSString *pVal = [FreestarCustomSegmentProperties getCustomSegmentProperty:pKey];
    return [pVal cStringUsingEncoding:NSASCIIStringEncoding];
}

const char* _Nullable _getAllCustomSegmentProperties(void) {
    NSDictionary *props = [FreestarCustomSegmentProperties getAllCustomSegmentProperties];
    if(props.count <= 0){
        return NULL;
    }
    
    NSData *jsonRep = [NSJSONSerialization dataWithJSONObject:props options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonRep encoding:NSUTF8StringEncoding];
    
    return [jsonString cStringUsingEncoding:NSASCIIStringEncoding];
}


void _deleteCustomSegmentProperty(char* key) {
    NSString *pKey = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];

    [FreestarCustomSegmentProperties deleteCustomSegmentProperty:pKey];
}

void _deleteAllCustomSegmentProperties(void) {
    [FreestarCustomSegmentProperties deleteAllCustomSegmentProperties];
}

void _closeBannerAd(char* placement, int bannerAdSize) {
    NSString *placementString = [NSString stringWithCString:placement encoding:NSASCIIStringEncoding];
    FreestarUnityBannerAdListener *listener = bannerListeners[placementString];
    [listener.ad removeFromSuperview];
    bannerListeners[placementString] = nil;
}

void _showBannerAd(char* placement, int bannerAdSize, int bannerAdPosition) {
    NSString *placementString = [NSString stringWithCString:placement encoding:NSASCIIStringEncoding];
    if (bannerListeners == nil) {
        bannerListeners = [[NSMutableDictionary alloc] init];
    }
    
    FreestarUnityBannerAdListener *listener = bannerListeners[placementString];
    if(listener == nil) {
        listener = [[FreestarUnityBannerAdListener alloc] initWithUnityListenerName:bannerListenerName];
        bannerListeners[placementString] = listener;
    }
    
    FreestarBannerAdSize requestedSize = bannerAdSize == 0 ? FreestarBanner320x50 : FreestarBanner300x250;
    
    
    listener.ad = [[FreestarBannerAd alloc] initWithDelegate:listener andSize:requestedSize];
    listener.ad.size = requestedSize;
    listener.adPosition = bannerAdPosition;
    [listener.ad loadPlacement:placementString];
}

bool _isBannerAdShowing(char* placement, int bannerAdSize) {
    NSString *placementString = [NSString stringWithCString:placement encoding:NSASCIIStringEncoding];
    FreestarUnityBannerAdListener *listener = bannerListeners[placementString];
    
    if(listener == nil) {
        return false;
    }
    return [listener isShowing];
}

