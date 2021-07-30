//
//  ViewController.m
//
//  Created by Lev Trubov on 9/30/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+FreestarAds.h"
#import "PartnerSelectionTableViewController.h"

@import FreestarAds;

static NSString *CONTENT = @"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4";

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, PartnerSelectionViewControllerDelegate> {
    UILabel *prompt;
    UIPickerView *adTypePicker;
    NSArray *adTypes;

    UIButton *loadButton, *showButton;
    UILabel *prerollFullscreenPrompt;

    UILabel *inviewAdPrompt;

    UILabel *partnerSelectionPrompt;
    UISwitch *partnerSelectionToggle;

    NSLayoutConstraint *inviewContainerPortraitYPos;
    NSLayoutConstraint *inviewContainerLandscapeYPos;
    NSLayoutConstraint *inviewContainerPortraitXPox;
    NSLayoutConstraint *inviewContainerLandscapeXPos;

    UILabel *placementPrompt;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    adTypeLoadedStates = [@[@NO,@NO,@NO,@NO,@NO,@NO,@NO] mutableCopy];

    adTypes = @[@"Interstitial",
                @"Rewarded",
                @"Banner",
                @"Preroll",
                @"Small Banner",
                @"Medium Native",
                @"Small Native"];

    CGFloat nativePortraitWidth = UIScreen.mainScreen.nativeBounds.size.width/UIScreen.mainScreen.scale;

    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        // Fallback on earlier versions
        self.view.backgroundColor = UIColor.whiteColor;
    }
    self.title = @"Freestar";

    prompt = [[UILabel alloc] init];
    prompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    prompt.text = @"Ad Type:";
    [prompt sizeToFit];
    [self.view addSubview:prompt];
    prompt.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [prompt.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20].active = YES;
        [prompt.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:10].active = YES;
    } else {
        [prompt.topAnchor constraintEqualToAnchor:self.topLayoutGuide.topAnchor].active = YES;
        [prompt.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;

    }
    [prompt.heightAnchor constraintEqualToConstant:prompt.frame.size.height].active = YES;

    adTypePicker = [[UIPickerView alloc] init];
    adTypePicker.dataSource = self;
    adTypePicker.delegate = self;
    [self.view addSubview: adTypePicker];
    adTypePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [adTypePicker.centerYAnchor constraintEqualToAnchor:prompt.centerYAnchor].active = YES;
    [adTypePicker.leftAnchor constraintEqualToAnchor:prompt.rightAnchor constant:20].active = YES;
    [adTypePicker.heightAnchor constraintEqualToConstant:216.0].active = YES;

    partnerSelectionPrompt = [[UILabel alloc] init];
    partnerSelectionPrompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    partnerSelectionPrompt.text = @"Choose Partner";
    [partnerSelectionPrompt sizeToFit];
    [self.view addSubview:partnerSelectionPrompt];
    partnerSelectionPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [partnerSelectionPrompt.topAnchor constraintEqualToAnchor:prompt.bottomAnchor constant:20].active = YES;
    [partnerSelectionPrompt.leadingAnchor constraintEqualToAnchor:prompt.leadingAnchor ].active = YES;

    partnerSelectionToggle = [[UISwitch alloc] init];
    [self.view addSubview:partnerSelectionToggle];
    partnerSelectionToggle.translatesAutoresizingMaskIntoConstraints = NO;
    [partnerSelectionToggle.centerYAnchor constraintEqualToAnchor:partnerSelectionPrompt.centerYAnchor].active = YES;
    [partnerSelectionToggle.leadingAnchor constraintEqualToAnchor:partnerSelectionPrompt.trailingAnchor constant:10].active = YES;



    publisherVideo = [[AVPlayerViewController alloc] init];
    publisherVideo.player = [AVPlayer playerWithURL:[self sampleContentVideo]];
    [self.view addSubview:publisherVideo.view];
    publisherVideo.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [publisherVideo.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
        [publisherVideo.view.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor].active = YES;

    } else {
        [publisherVideo.view.bottomAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
        [publisherVideo.view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;

    }
    [publisherVideo.view.widthAnchor constraintEqualToConstant:nativePortraitWidth].active = YES;
    [publisherVideo.view.heightAnchor constraintEqualToAnchor:publisherVideo.view.widthAnchor multiplier:0.5625].active = YES; //9:16 aspect ratio

    publisherVideo.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    publisherVideo.showsPlaybackControls = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mainContentDone:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[publisherVideo.player currentItem]];

    loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadButton setTitle:@"Load" forState:UIControlStateNormal];
    [loadButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [loadButton addTarget:self action:@selector(loadSelectedAdType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadButton];
    loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [loadButton.leftAnchor constraintEqualToAnchor:prompt.leftAnchor].active = YES;
    [loadButton.topAnchor constraintEqualToAnchor:partnerSelectionToggle.bottomAnchor constant:5].active = YES;

    showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showButton setTitle:@"Show" forState:UIControlStateNormal];
    showButton.enabled = NO;
    [showButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [showButton addTarget:self action:@selector(showSelectedAdType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    showButton.translatesAutoresizingMaskIntoConstraints = NO;
    [showButton.leftAnchor constraintEqualToAnchor:loadButton.rightAnchor constant:20].active = YES;
    [showButton.topAnchor constraintEqualToAnchor:loadButton.topAnchor].active = YES;
    [showButton.heightAnchor constraintEqualToAnchor:loadButton.heightAnchor].active = YES;

    prerollFullscreenPrompt = [[UILabel alloc] init];
    prerollFullscreenPrompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    prerollFullscreenPrompt.text = @"Fullscreen";
    [prerollFullscreenPrompt sizeToFit];
    [self.view addSubview:prerollFullscreenPrompt];
    prerollFullscreenPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [prerollFullscreenPrompt.centerYAnchor constraintEqualToAnchor:showButton.centerYAnchor].active = YES;
    [prerollFullscreenPrompt.leadingAnchor constraintEqualToAnchor:showButton.trailingAnchor constant:50].active = YES;

    prerollFullscreenToggle = [[UISwitch alloc] init];
    [self.view addSubview:prerollFullscreenToggle];
    prerollFullscreenToggle.translatesAutoresizingMaskIntoConstraints = NO;
    [prerollFullscreenToggle.centerYAnchor constraintEqualToAnchor:showButton.centerYAnchor].active = YES;
    [prerollFullscreenToggle.leadingAnchor constraintEqualToAnchor:prerollFullscreenPrompt.trailingAnchor constant:20].active = YES;

    prerollFullscreenPrompt.hidden = YES;
    prerollFullscreenToggle.hidden = YES;

    placementPrompt = [[UILabel alloc] init];
    placementPrompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    placementPrompt.text = @"Ad Placement:";
    [placementPrompt sizeToFit];
    [self.view addSubview:placementPrompt];
    placementPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [placementPrompt.topAnchor constraintEqualToAnchor:loadButton.bottomAnchor constant:10].active = YES;
    [placementPrompt.leadingAnchor constraintEqualToAnchor:prompt.leadingAnchor ].active = YES;

    placement = [[UITextField alloc] init];
    placement.placeholder = @"Input placement";
    placement.clearButtonMode = UITextFieldViewModeWhileEditing;
    placement.borderStyle = UITextBorderStyleRoundedRect;
    placement.returnKeyType = UIReturnKeyDone;
    placement.delegate = self;
    [self.view addSubview:placement];
    placement.translatesAutoresizingMaskIntoConstraints = NO;
    [placement.topAnchor constraintEqualToAnchor:placementPrompt.topAnchor].active = YES;
    [placement.leadingAnchor constraintEqualToAnchor:placementPrompt.trailingAnchor constant:10].active = YES;

    inviewAdContainer = [[UIView alloc] init];
    inviewAdContainer.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:inviewAdContainer];
    inviewAdContainer.translatesAutoresizingMaskIntoConstraints = NO;

    inviewContainerPortraitYPos = [inviewAdContainer.topAnchor constraintEqualToAnchor:loadButton.bottomAnchor constant:50];
    inviewContainerLandscapeYPos = [inviewAdContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
    inviewContainerPortraitXPox = [inviewAdContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
    inviewContainerLandscapeXPos = [inviewAdContainer.rightAnchor constraintEqualToAnchor:self.view.rightAnchor];

    inviewContainerPortraitXPox.active = YES;
    inviewContainerPortraitYPos.active = YES;

    [inviewAdContainer.widthAnchor constraintEqualToConstant:330].active = YES;
    [inviewAdContainer.heightAnchor constraintEqualToConstant:300].active = YES;


    inviewAdPrompt = [[UILabel alloc] init];
    inviewAdPrompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    inviewAdPrompt.text = @"Inview ad:";
    [inviewAdPrompt sizeToFit];
    [inviewAdContainer addSubview:inviewAdPrompt];
    inviewAdPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [inviewAdPrompt.leadingAnchor constraintEqualToAnchor:inviewAdContainer.leadingAnchor constant:10].active = YES;
    [inviewAdPrompt.topAnchor constraintEqualToAnchor:inviewAdContainer.topAnchor constant:10].active = YES;

    prerollFullscreenPrompt.hidden = YES;
    prerollFullscreenToggle.hidden = YES;
    publisherVideo.view.hidden = YES;

    inviewAdContainer.hidden = YES;
}

#pragma mark - Picker Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 7;
}

#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return adTypes[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([adTypes[row] isEqualToString:@"Preroll"]) {
        prerollFullscreenPrompt.hidden = NO;
        prerollFullscreenToggle.hidden = NO;
        publisherVideo.view.hidden = NO;
        [publisherVideo.player play];
    } else {
        prerollFullscreenPrompt.hidden = YES;
        prerollFullscreenToggle.hidden = YES;
        [publisherVideo.player pause];
        publisherVideo.view.hidden = YES;
    }

    if([adTypes[row] isEqualToString:@"Banner"] ||
       [adTypes[row] isEqualToString:@"Small Banner"] ||
       [adTypes[row] isEqualToString:@"Medium Native"] ||
       [adTypes[row] isEqualToString:@"Small Native"]) {
        inviewAdContainer.hidden = NO;
        [self bannerViewHidden:NO];
    } else {
        inviewAdContainer.hidden = YES;
        [self bannerViewHidden:YES];
    }

    [self adjustUIForAdState];
}

#pragma mark - Publisher content

-(NSURL *)sampleContentVideo {
    NSURL *local = [[NSBundle mainBundle] URLForResource:@"bunny" withExtension:@"mp4"];
    return local ? local : [NSURL URLWithString:CONTENT];
}

- (void)mainContentDone:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

#pragma mark - button actions

-(void)loadSelectedAdType:(id)sender {
    NSString *adType = adTypes[[adTypePicker selectedRowInComponent:0]];

    if(partnerSelectionToggle.on) {
        [self.navigationController pushViewController:[[PartnerSelectionTableViewController alloc] initWithAdType:adType andDelegate:self] animated:YES];
    } else {
        chosenPartners = @[];

        [self callSDKLoad:adType];
    }
}

-(void)partnersSelected:(NSArray<NSString *>*)partners {
    chosenPartners = partners;

    [self callSDKLoad:adTypes[[adTypePicker selectedRowInComponent:0]]];
}

-(void)callSDKLoad:(NSString *)adType {
    if([adType isEqualToString:@"Interstitial"]) {
        [self loadInterstitialAd];
    } else if([adType isEqualToString:@"Rewarded"]) {
        [self loadRewardAd];
    } else if([adType isEqualToString:@"Banner"]) {
        [self loadBannerAd];
    } else if([adType isEqualToString:@"Preroll"]) {
        [self loadPrerollAd];
    } else if([adType isEqualToString:@"Small Banner"]) {
        [self loadSmallBannerAd];
    } else if([adType isEqualToString:@"Medium Native"]) {
        [self loadMediumNativeAd];
    } else if([adType isEqualToString:@"Small Native"]) {
        [self loadSmallNativeAd];
    }
}

-(void)showSelectedAdType:(id)sender {
    NSString *adType = adTypes[[adTypePicker selectedRowInComponent:0]];

    if([adType isEqualToString:@"Interstitial"]) {
        [self showInterstitialAd];
    } else if([adType isEqualToString:@"Rewarded"]) {
        [self showRewardAd];
    } else if([adType isEqualToString:@"Preroll"]) {
        [self showPrerollAd];
    } else if([adType isEqualToString:@"Banner"]) {
        [self showBannerAd];
    } else if([adType isEqualToString:@"Small Banner"]) {
        [self showSmallBannerAd];
    } else if([adType isEqualToString:@"Medium Native"]) {
        [self showMediumNativeAd];
    } else if([adType isEqualToString:@"Small Native"]) {
        [self showSmallNativeAd];
    }
}

#pragma mark - UI correctness

-(void)adjustUIForAdState {
    BOOL relevantAdTypeState = [adTypeLoadedStates[[adTypePicker selectedRowInComponent:0]] boolValue];
    showButton.enabled = relevantAdTypeState;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIInterfaceOrientation orient =  UIApplication.sharedApplication.statusBarOrientation;

        if(orient == UIInterfaceOrientationPortrait) {
            self->inviewContainerLandscapeYPos.active = NO;
            self->inviewContainerLandscapeXPos.active = NO;
            self->inviewContainerPortraitYPos.active = YES;
            self->inviewContainerPortraitXPox.active = YES;
        } else {
            self->inviewContainerPortraitYPos.active = NO;
            self->inviewContainerPortraitXPox.active = NO;
            self->inviewContainerLandscapeYPos.active = YES;
            self->inviewContainerLandscapeXPos.active = YES;
        }

    } completion:nil];


    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
