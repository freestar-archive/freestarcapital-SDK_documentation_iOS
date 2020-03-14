//
//  ViewController.h
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 9/30/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVKit;

@interface ViewController : UIViewController {
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

