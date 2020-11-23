//
//  VdopiaiOSBridge.h
//
//
//  Created by Sachin Patil on 02/08/17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif
    
    void UnitySendMessage(const char* obj, const char* method, const char* msg);
    
#ifdef __cplusplus
}
#endif

void _initWithAPIKey(char *apiKey);
void _setupWithListener(char *listenerName);
void _loadInterstitialAd(char *placement);
void _showInterstitialAd(char* placement);
void _loadRewardedAd(char *placement);
void _showRewardedAd(char* placement, int rewardAmount,char* rewardName, char* userId, char* secretKey);

void _setCoppaStatus(_Bool coppa);
void _setDemograpics(int age, char* birthDate, char* gender, char* maritalStatus,
                     char* ethnicity);
void _setLocation(char* dmaCode, char* postal, char* curPostal, char* latitude, char* longitude);

void _setPrivacySettings(_Bool gdprApplies, char* gdprConsentString);

void _setCustomSegmentProperty(char* key, char* value);
const char* _Nullable _getCustomSegmentProperty(char* key);
const char* _Nullable _getAllCustomSegmentProperties(void);

void _deleteCustomSegmentProperty(char* key);
void _deleteAllCustomSegmentProperties(void);

void _setBannerListener(char *listenerName);
void _closeBannerAd(char* placement, int bannerAdSize);
void _showBannerAd(char* placement, int bannerAdSize, int bannerAdPosition);
bool _isBannerAdShowing(char* placement, int bannerAdSize);

NS_ASSUME_NONNULL_END
