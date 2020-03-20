# FreeStar Ads Mediation SDK

## Changelog

##### 2020-03-20
Version 3.2.1: modifications to API for convenience
1. Fullscreen ads (interstitial and rewarded) are now instance objects, and multiple instances can be created within the same app session, rather than being called by static methods. One should, however, be careful to only display one fullscreen ad at a time.
2. An explicit `loadPlacement:` method has been added to the banner ad, and can be called before adding the banner ad to the app's view hierarchy. In case the ad has been added to the view hierarchy before it is loaded, there is also an explicit `show` method that can be invoked once the ad is loaded.
3. All ads now have the `winningPartnerName` method that can be used to retrieve the ad auction winner, if the ad has a fill.

## Overview

FreeStar provides an effective ad mediation solution.  The FreeStar mediation method is universal auction, not the traditional waterfall.  Universal auction is more sophisticated than waterfall and provides, by far, the best eCPM.
This document describes how to integrate the FreeStar SDK into your native iOS app quickly and easily.  This repo is a fully integrated iOS sample app.  Feel free to clone it, install the appropriate Cocoapods, open with Xcode and run it on a device.

<blockquote>
  Note: You can remotely toggle on/off any of the following ad providers as you see fit using our web dashboard.  
  <i>All</i> applicable providers are enabled by default.
</blockquote>

<table>
  <tr><td>Ad Provider</td><td>SDK Version</td><td>Ad Unit Types</td></tr>

  <tr>  <td>AdColony</td> <td>4.1.4</td>  <td>Fullscreen Interstitial & Rewarded</td> </tr>
  <tr>  <td>Amazon</td> <td>3.0.0</td>  <td>Fullscreen Interstitial & Rewarded, Banner 300x250, Banner 320x50, Preroll</td> </tr>
  <tr>  <td>AppLovin</td> <td>6.11.5</td>  <td>Fullscreen Interstitial & Rewarded, Banner 300x250, Banner 320x50</td>  </tr>
  <tr>  <td>Criteo</td> <td>3.4.2</td>  <td>Fullscreen Interstitial & Rewarded, Banner 300x250, Banner 320x50</td> </tr>

  <tr>  <td>Facebook</td> <td>5.7.1</td>  <td>Fullscreen Interstitial & Rewarded, Banner 300x250</td> </tr>
  <tr>  <td>Admob</td> <td>7.53.1</td>  <td>Fullscreen Interstitial & Rewarded, Banner 300x250, Banner 320x50</td> </tr>
  <tr>  <td>Google Ads Manager</td> <td>7.53.1</td>  <td>Fullscreen Interstitial & Rewarded, Banner 300x250, Banner 320x50</td> </tr>

  <tr>  <td>MoPub</td> <td>5.10.0</td>  <td>Fullscreen Interstitial & Rewarded, Banner 300x250, Banner 320x50</td> </tr>
  <tr>  <td>Tapjoy</td> <td>12.4.2</td>  <td>Fullscreen Rewarded</td> </tr>
  <tr>  <td>Unity Ads</td> <td>3.4.2</td>  <td>Fullscreen Interstitial & Rewarded</td> </tr>
  <tr>  <td>Vungle</td> <td>6.4.6</td>  <td>Fullscreen Interstitial & Rewarded</td> </tr>
  <tr>  <td>Google IMA</td> <td>3.11.3</td>  <td>Preroll</td> </tr>

</table>

<h2>Project Setup</h2>

Your <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/Podfile">Podfile</a> should have the following:


```
# Uncomment the next line to define a global platform for your project
platform :ios, '9.0' # minimum ios version

target 'FreestarOBJCSample' do # app name
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  pod 'FreestarAds', '~> 3.2' # required

  # Only specify the partners for which you want to run ads
  pod 'FreestarAds-AdColony', '~> 3.1'
  pod 'FreestarAds-AppLovin', '~> 3.2'
  pod 'FreestarAds-Googleadmob', '~> 2.2'
  pod 'FreestarAds-Tapjoy', '~> 3.1'
  pod 'FreestarAds-Unity', '~> 4.1'
  pod 'FreestarAds-Vungle', '~> 3.1'
  pod 'FreestarAds-Amazon', '~> 2.1'
  pod 'FreestarAds-Google', '~> 3.0'
  pod 'FreestarAds-Criteo', '~> 1.0'
  pod 'FreestarAds-GAM', '~> 1.0'
  pod 'FreestarAds-Facebook', '~> 3.1'
  pod 'FreestarAds-Mopub', '~> 3.2'

end
```

Once the podfile is setup, enter the Xcode project's base directory in the terminal and run `pod install`. Then open the generated `.xcworkspace` project with Xcode.

<h3>Info.plist</h3>

If you have included the Google Ad Manager as one of your desired ad partners, you will need to place the following into the app's `Info.plist` file:

```
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
<key>GADIsAdManagerApp</key>
<true/>
```

The `GADApplicationIdentifier` key is also required for Admob ads.

If you have included AdColony as one of your desired ad partners, you will need to place the following into your app's `Info.plist` file (changing the reasons to be appropriate for your app):

```
<key>NSCalendarsUsageDescription</key>
<string>Adding events</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Taking selfies</string>
<key>NSCameraUsageDescription</key>
<string>Taking selfies</string>
<key>NSMotionUsageDescription </key>
<string>Interactive ad controls</string>
```

To interface with the Freestar ad mediation, have the following at the top of the code file where you want to make use of the SDK:

`import FreestarAds;`

<h3>GDPR Support</h3>

FreeStar is GDPR-ready and supports the IAB Standards for GDPR compliance.

Use the following simple api in conjunction with your existing Consent Management Provider.  If you do not have a CMP solution, that’s ok, too!  Our mediation sdk will detect if the user is in the EU and automatically apply GDPR actions to the ad request.  So, by default, you do not have to do any extra work to use our sdk in a GDPR-compliant fashion.

<pre>
// Save GDPR consent string
[[Freestar privacySettings] subjectToGDPR:gdprApplies withConsent:gdprConsentString];
</pre>

<h2>Initialize FreeStar</h2>

FreeStar must be initialized in the `application:didFinishLaunchingWithOptions:` of your `AppDelegate` (or at another time as close as possible to the app launch). This gives the prefetch mechanism time work and thus, makes ad fill more likely when a request is made.

```
static NSString* const FREESTAR_API_KEY = @"P8RIA3";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Freestar initWithAdUnitID:FREESTAR_API_KEY];

    //more initialization code

    return YES;
}
```

<h2>Interstitial Ad</h2>

Implement the `FreestarInterstitialDelegate` protocol in one of your classes:

```
-(void)freestarInterstitialLoaded:(FreestarInterstitialAd *)ad {}
-(void)freestarInterstitialFailed:(FreestarInterstitialAd *)ad because:(FreestarNoAdReason)reason {}
-(void)freestarInterstitialShown:(FreestarInterstitialAd *)ad {}
-(void)freestarInterstitialClicked:(FreestarInterstitialAd *)ad {}
-(void)freestarInterstitialClosed:(FreestarInterstitialAd *)ad {}
```

This allows your app to listen to ad events and act appropriately. You will pass an instance of this object to the Freestar SDK when loading interstitial ad. In the current sample app, the class implementing this protocol is the `ViewController`, and the implementation is located in  <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m">ViewController+FreestarAds.m</a>

```
//self is the object that implements FreestarInterstitialDelegate
self.interstitial = [[FreestarInterstitialAd alloc] initWithDelegate:self];

//You can load associated to a placement as follows, or pass in
//nil for the default placement
[interstitial loadPlacement:@"interstitial_p1"];
```

<blockquote>
If you plan to use more than one placement in your app, please adhere to the placement naming convention
as follows:  
<br>

  "my_placement_name_pN", where N is the number of your placement.  


For example, let us
assume you are using 2 interstitial ad placements in your game or app.  The first placement would be
the default placement; simply do not specify a placement name by calling the <strong>loadPlacement:</strong> method with nil as the argument.  The second placement would be, for example,  "my_search_screen_p1".  The ending
"p1" tells the SDK to use the second placement you created in our web dashboard for the interstitial ad unit.

This placement format is the same for all the other ad units, such as rewarded ads and banner ads.
</blockquote>

When the interstitial ad is ready, the <strong>freestarInterstitialLoaded:</strong> callback will occur.

```
-(void)freestarInterstitialLoaded:(FreestarInterstitialAd *)ad {
  //self in this case should be an instance of UIViewController
  [ad showFrom:self];  //You can display the ad now OR show it later; your choice.
}
```

There are other callbacks that will occur in other events, such as in the rare event where a load ad request
does not result in a fill.  Please see the <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m">ViewController+FreestarAds.m</a> on this sample for those details.

<blockquote>
❗⚠Warning: Attempting to load a new ad from the <code>freestarInterstitialFailed:because:</code> method is <strong>strongly</strong> discouraged. If you must load an ad from <code>freestarInterstitialFailed:because:</code>, limit ad load retries to avoid continuous failed ad requests in situations such as limited network connectivity.
</blockquote>


<h2>Banner Ad</h2>

FreeStar supports <strong>300x250</strong> and <strong>320x50</strong> banner ad formats and allows you to
control the refresh intervals remotely.

```
    smallBanner = [[FreestarBannerAd alloc] initWithDelegate:self     
      andSize:FreestarBanner320x50];
    [smallBanner loadPlacement:nil]; //or pass in specific placement
```

When the banner ad is ready, the <strong>freestarBannerLoaded:</strong> callback will occur.

```
-(void)freestarBannerLoaded:(FreestarBannerAd *)ad {
  NSLog(@"banner ad as been loaded: %@", ad);
}
```

If you insert the banner ad into the view hierarchy at this point, the ad will display automatically. If you already inserted the ad into the view hierarchy, you should call the `show` method to display it:

```
-(void)freestarBannerLoaded:(FreestarBannerAd *)ad {
  [ad show];
}
```

Banner ads can also be specified in Interface Builder layout and will be automatically loaded. If you do this, however, you will need to set the `size` and `delegate` properties on the ad object, and call the `show` method after receiving the `freestarBannerLoaded:` callback.

<h2>Rewarded Ad</h2>

<blockquote>
  A common myth regarding Rewarded Ads is publishers are required to <i>give something</i> to the user.
  But, that's not true.  You can simply tell the user they must watch the ad in order to be able to
  proceed to the next level or proceed to content.
</blockquote>

Implement the `FreestarRewardedDelegate` protocol in one of your classes:

```
-(void)freestarRewardedLoaded:(FreestarRewardedAd *)ad {}
-(void)freestarRewardedFailed:(FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {}
-(void)freestarRewardedShown:(FreestarRewardedAd *)ad {}
-(void)freestarRewardedClosed:(FreestarRewardedAd *)ad {}
-(void)freestarRewardedFailedToStart:(FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {}
-(void)freestarRewardedAd:(FreestarRewardedAd *)ad received:(NSString *)rewardName amount:(NSInteger)rewardAmount {}
```

This allows your app to listen to ad events and act appropriately. You will pass an instance of this object to the Freestar SDK when loading rewarded ad. In the current sample app, the class implementing this protocol is the `ViewController`, and the implementation is located in  <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m">ViewController+FreestarAds.m</a>

```
//this may be overriden in the ad portal
FreestarReward *rew = [FreestarReward blankReward];
rew.rewardName = @"Coins";
rew.rewardAmount = 1000;

//self is the object that implements FreestarRewardedDelegate
self.rewarded = [[FreestarRewardedAd alloc] initWithDelegate:self
  andReward:rew];
[rewarded loadPlacement:@"rewarded_p1"]; //or pass in nil for default
```

When the rewarded ad is ready, the <strong>freestarRewardedLoaded:</strong> callback will occur.

```
-(void)freestarRewardedLoaded:(FreestarRewardedAd *)ad {
  //self in this case should be an instance of UIViewController
  [ad showFrom:self];  //You can display the ad now OR show it later; your choice.
}
```

When the user has fully watched the rewarded ad (or when the given ad partner determines sufficient watch time for the reward), the following callback will occur:

```
-(void)freestarRewardedAd:(FreestarRewardedAd*)ad received:(NSString *)rewardName {} amount:(NSInteger)rewardAmount {
  //allow user to proceed to app content or next level in app/game
  //can use the name/amount to show change in UI
}
```


When the user has closed the rewarded ad, the following callback will occur:

```
-(void)freestarRewardedClosed {}
```

<blockquote>
  If the user does not watch the rewarded ad thru to completion, <strong>freestarRewardedAd:received:amount:</strong> will not occur.
  However, the <strong>freestarRewardedClosed</strong> will always occur when the rewarded ad is dismissed
  regardless if the user watched the entire rewarded ad or not.
</blockquote>

<blockquote>
❗⚠ Please assume that ads will expire in about 1 hour after the loaded callback.  Meaning, you may <i>cache</i> an ad
  in your app or game, but must be displayed with the allotted hour.
</blockquote>

<h2>Sample Project</h2>
<b>
All of this and more, such as <i>Preroll Ads</i> can be seen in the sample <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m">ViewController+FreestarAds.m</a>:
</b>

https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m
