//
//  PartnerSelectionTableViewController.h
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const ChocolateSelectedNotification = @"ChocolatePartnersSelectedNotification";

@interface PartnerSelectionTableViewController : UITableViewController

-(instancetype)initWithAdType:(NSString *)adType;

@end

NS_ASSUME_NONNULL_END
