//
//  AppDelegate.m
//  FreestarOBJCSample
//
//  Copyright © 2020 Freestar. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@import FreestarAds;

static NSString* const FREESTAR_API_KEY = @"XqjhRR";

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Freestar setAdaptiveBannerEnabledIfAvailable:YES];
    [Freestar initWithAppKey:FREESTAR_API_KEY];

    self.window = [[UIWindow alloc] init];
    self.window.frame = UIScreen.mainScreen.bounds;
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    [Freestar requestAppOpenAdsWithPlacement:@"interstitial_p1"
                                  waitScreen:YES
                                  completion:^(NSString * _Nonnull placement, FreestarAppOpenAdEvent event, NSError * _Nullable error) {
        NSLog(@"%ld", event);
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

    return YES;
}


@end
