//
//  AppDelegate.m
//  FreestarOBJCSample
//
//  Created by Vdopia Developer on 3/13/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@import FreestarAds;

static NSString* const FREESTAR_API_KEY = @"P8RIA3";

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Freestar initWithAdUnitID:FREESTAR_API_KEY];
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = UIScreen.mainScreen.bounds;
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    return YES;
}


@end
