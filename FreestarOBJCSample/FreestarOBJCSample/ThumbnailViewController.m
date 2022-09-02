//
//  ThumbnailViewController.m
//
//  Created by Carlos Alcala on 9/02/22.
//  Copyright © 2019. All rights reserved.
//

#import "ThumbnailViewController.h"
#import <UIKit/UIKit.h>
#import <FreestarAds/Freestar.h>
#import <FreestarAds/FreestarThumbnailAd.h>


@interface ThumbnailViewController()<FreestarThumbnailAdDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) FreestarThumbnailAd *thumbnailAd;
@property (nonatomic, assign) BOOL thumbnailAdReady;

@end

@implementation ThumbnailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupConfig];

}

- (void)setupConfig {
    [FreestarThumbnailAd setWhitelistBundleIdentifiers:@[@"io.freestar.ads.FreestarSwiftSample"]];
    [FreestarThumbnailAd setBlacklistViewControllers:@[@"BlackViewController",@"FullscreenAdViewControllerPush",@"FullscreenAdViewController"]];
    [FreestarThumbnailAd setGravity:TopLeft];
    [FreestarThumbnailAd setXMargin:100];
    [FreestarThumbnailAd setYMargin:500];
}

-(void)loadThumbnailAd {
    self.thumbnailAd = [[FreestarThumbnailAd alloc] init];
    self.thumbnailAd.delegate = self;
    [self.thumbnailAd load];
}

-(void)showThumbnailAd {
    [self.thumbnailAd show];
}

-(void)onThumbnailLoaded:(FreestarThumbnailAd *) thumbnail {
}

-(void)onThumbnailFailed:(FreestarThumbnailAd *) because reason: (FreestarNoAdReason*) thumbnail {
    self.thumbnailAdReady = NO;
}

-(void)onThumbnailShown:(FreestarThumbnailAd *) thumbnail {
}

-(void)onThumbnailClicked:(FreestarThumbnailAd *) thumbnail {
}

-(void)onThumbnailClosed:(FreestarThumbnailAd *) thumbnail {
    self.thumbnailAdReady = NO;
}

-(void)onThumbnailDismissed: (FreestarThumbnailAd *) thumbnail {
    self.thumbnailAdReady = NO;
}

@end

