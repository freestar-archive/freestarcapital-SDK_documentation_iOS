//
//  ThumbnailViewController.h
//
//  Created by Carlos Alcala on 8/30/22.
//  Copyright © 2019. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVKit;

@interface ThumbnailViewController : UIViewController {
    NSString *appName; //for logging
    NSMutableArray<NSNumber *> *adTypeLoadedStates;
    UIView *inviewAdContainer;

    AVPlayerViewController *publisherVideo;
    UISwitch *prerollFullscreenToggle;
    NSArray *chosenPartners;

    UITextField *placement;
}

-(void)adjustUIForAdState;


@end
