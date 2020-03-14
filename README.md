# FreeStar Ads Mediation SDK
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
  pod 'ChocolatePlatform-SDK-AdColony', '~> 3.1'
  pod 'ChocolatePlatform-SDK-AppLovin', '~> 3.2'
  pod 'ChocolatePlatform-SDK-Googleadmob', '~> 2.2'
  pod 'ChocolatePlatform-SDK-Tapjoy', '~> 3.1'
  pod 'ChocolatePlatform-SDK-Unity', '~> 4.1'
  pod 'ChocolatePlatform-SDK-Vungle', '~> 3.1'
  pod 'ChocolatePlatform-SDK-Amazon', '~> 2.1'
  pod 'ChocolatePlatform-SDK-Google', '~> 3.0'
  pod 'ChocolatePlatform-SDK-Criteo', '~> 1.0'
  pod 'ChocolatePlatform-SDK-GAM', '~> 1.0'
  pod 'ChocolatePlatform-SDK-Facebook', '~> 3.1'
  pod 'ChocolatePlatform-SDK-Mopub', '~> 3.2'

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
-(void)freestarInterstitialLoaded:(NSString *)winningPartner {}
-(void)freestarInterstitialFailed:(FreestarNoAdReason)reason {}
-(void)freestarInterstitialShown {}
-(void)freestarInterstitialClicked {}
-(void)freestarInterstitialClosed {}
```

This allows your app to listen to ad events and act appropriately. You will pass an instance of this object to the Freestar SDK when loading interstitial ad. In the current sample app, the class implementing this protocol is the `ViewController`, and the implementation is located in  <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m">ViewController+FreestarAds.m</a>

```
//self is the object that implements FreestarInterstitialDelegate
[FreestarInterstitialAd loadWithDelegate:self];

//You can also load associated to a placement as follows
//[FreestarInterstitialAd loadWithDelegate:self     
                              forPlacement:@"interstitial_p1"];
```

<blockquote>
If you plan to use more than one placement in your app, please adhere to the placement naming convention
as follows:  
<br>

  "my_placement_name_pN", where N is the number of your placement.  


For example, let us
assume you are using 2 interstitial ad placements in your game or app.  The first placement would be
the default placement; simply do not specifiy a placement name by using the <strong>[FreestarInterstitialAd loadWithDelegate:]</strong> method without
the placement parameter.  The second placement would be, for example,  "my_search_screen_p1".  The ending
"p1" tells the SDK to use the second placement you created in our web dashboard for the interstitial ad unit.

This placement format is the same for all the other ad units, such as rewarded ads and banner ads.
</blockquote>

When the interstitial ad is ready, the <strong>freestarInterstitialLoaded:</strong> callback will occur.

```
-(void)freestarInterstitialLoaded:(NSString *)winningPartner {
  //self in this case should be an instance of UIViewController
  [FreestarInterstitialAd showFrom:self];  //You can display the ad now OR show it later; your choice.

  //Note: Placement will be null if not specified in the original
  //loadWithDelegate request.
}
```

There are other callbacks that will occur in other events, such as in the rare event where a load ad request
does not result in a fill.  Please see the <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m">ViewController+FreestarAds.m</a> on this sample for those details.

<blockquote>
❗⚠Warning: Attempting to load a new ad from the <code>freestarInterstitialFailed:</code> method is <strong>strongly</strong> discouraged. If you must load an ad from <code>freestarInterstitialFailed:</code>, limit ad load retries to avoid continuous failed ad requests in situations such as limited network connectivity.
</blockquote>


<h2>Banner Ad</h2>

FreeStar supports <strong>300x250</strong> and <strong>320x50</strong> banner ad formats and allows you to
control the refresh intervals remotely.

```
    smallBanner = [[FreestarBannerAd alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    smallBanner.delegate = self;
    smallBanner.placement = @"my_banner_placement_p1";

    smallBanner.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:smallBanner];

    //Note: 'placement' is OPTIONAL and only if
    //you plan to have more than one Banner placement.
```

The ad will automatically load and display upon being added to the view hierarchy. Thus, to make sure the correct placement is loaded, the `placement` property needs to be set before adding the `FreestarBannerAd` object to the view hierarchy.

When the banner ad is ready, the <strong>freestarBannerLoaded:</strong> callback will occur.

```
-(void)freestarBannerLoaded:(FreestarBannerAd *)ad {
  NSLog(@"banner ad as been loaded: %@", ad);
}
```

Banner ads can also be specified in Interface Builder layout and will be automatically loaded. The view size should be set to either `300x250` or `320x50` points, depending on the desired ad size.

<h2>Rewarded Ad</h2>

<blockquote>
  A common myth regarding Rewarded Ads is publishers are required to <i>give something</i> to the user.
  But, that's not true.  You can simply tell the user they must watch the ad in order to be able to
  proceed to the next level or proceed to content.
</blockquote>

Implement the `FreestarRewardedDelegate` protocol in one of your classes:

```
-(void)freestarRewardedLoaded:(NSString *)winningPartner {}
-(void)freestarRewardedFailed:(FreestarNoAdReason)reason {}
-(void)freestarRewardedShown {}
-(void)freestarRewardedClosed {}
-(void)freestarRewardedFailedToStart:(FreestarNoAdReason)reason {}
-(void)freestarRewardedReceived:(NSString *)rewardName {} amount:(NSInteger)rewardAmount {}
```

This allows your app to listen to ad events and act appropriately. You will pass an instance of this object to the Freestar SDK when loading rewarded ad. In the current sample app, the class implementing this protocol is the `ViewController`, and the implementation is located in  <a href="https://github.com/freestarcapital/SDK_documentation_iOS/blob/master/FreestarOBJCSample/FreestarOBJCSample/ViewController+FreestarAds.m">ViewController+FreestarAds.m</a>

```
//this may be overriden in the ad portal
FreestarReward *rew = [FreestarReward blankReward];
rew.rewardName = @"Coins";
rew.rewardAmount = 1000;

//self is the object that implements FreestarRewardedDelegate
[FreestarRewardedAd loadWithDelegate:self andReward:rew];

//You can also load associated to a placement as follows
//[FreestarRewardedAd loadWithDelegate:self
                             andReward:rew
                          forPlacement:@"rewarded_p1"];
```

When the rewarded ad is ready, the <strong>freestarRewardedLoaded:</strong> callback will occur.

```
-(void)freestarRewardedLoaded:(NSString *)winningPartner {
  //self in this case should be an instance of UIViewController
  [FreestarRewardedAd showFrom:self];  //You can display the ad now OR show it later; your choice.

  //Note: Placement will be null if not specified in the original
  //loadWithDelegate request.
}
```

When the user has fully watched the rewarded ad (or when the given ad partner determines sufficient watch time for the reward), the following callback will occur:

```
-(void)freestarRewardedReceived:(NSString *)rewardName {} amount:(NSInteger)rewardAmount {
  //allow user to proceed to app content or next level in app/game
  //can use the name/amount to show change in UI
}
```


When the user has closed the rewarded ad, the following callback will occur:

```
-(void)freestarRewardedClosed {}
```

<blockquote>
  If the user does not watch the rewarded ad thru to completion, <strong>freestarRewardedReceived:</strong> will not occur.
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
