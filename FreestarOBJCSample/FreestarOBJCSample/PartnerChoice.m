//
//  PartnerChoice.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/15/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "PartnerChoice.h"

@implementation PartnerChoice

-(instancetype)initWithName:(NSString *)n andSelected:(BOOL)s {
    self = [super init];
    self.name = n;
    self.selected = s;
    return self;
}

-(instancetype)initWithName:(NSString *)n {
    return [self initWithName:n andSelected:NO];
}

@end
