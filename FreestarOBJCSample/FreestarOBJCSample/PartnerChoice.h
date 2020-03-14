//
//  PartnerChoice.h
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/15/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartnerChoice : NSObject

-(instancetype)initWithName:(NSString *)n andSelected:(BOOL)s;
-(instancetype)initWithName:(NSString *)n;


@property NSString *name;
@property BOOL selected;

@end

NS_ASSUME_NONNULL_END
