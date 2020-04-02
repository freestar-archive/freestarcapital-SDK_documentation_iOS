//
//  PartnerSelectionTableViewController.h
//
//  Created by Lev Trubov on 10/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PartnerSelectionViewControllerDelegate
-(void)partnersSelected:(NSArray<NSString *>*)partners;
@end

@interface PartnerSelectionTableViewController : UITableViewController

-(instancetype)initWithAdType:(NSString *)adType
                  andDelegate:(id<PartnerSelectionViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
