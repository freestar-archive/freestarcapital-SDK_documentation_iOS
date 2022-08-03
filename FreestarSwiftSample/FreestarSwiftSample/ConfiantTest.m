//
//  ConfiantTest.m
//  FreestarSwiftSample
//
//  Created by Admin on 3/8/22.
//  Copyright © 2022 Freestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfiantTest.h"
#import "ConfiantSDK/ConfiantSDK.h"

@implementation ConfiantTest

#pragma mark - Confiant SDK

+ (void)confiantInitializeWith:(NSString *_Nonnull)propertyId {
    NSError * _Nullable errorIfAny = nil;

    NSLog(@"ConfiantSDK: propertyId: %@", propertyId);

    if (propertyId == nil) {
        NSLog(@"ConfiantSDK: Error: Property ID is invalid");
        return;
    }

    Settings * _Nullable settings = [Settings withPropertyId:propertyId error:&errorIfAny];
    if (errorIfAny == nil) {
        NSAssert(settings != nil, nil);
    } else {
        NSError * _Nonnull error = errorIfAny;
        NSString * _Nonnull const message = [NSString stringWithFormat:@"Failed to create Confiant Settings: %@ %ld", error.localizedDescription, (long)error.code];
        NSLog(@"ConfiantSDK: Error: %@", message);
        NSAssert(false, nil);
    }

    NSLog(@"ConfiantSDK: settings: %@", settings);

    //Confiant Initialize
    [Confiant initializeWithSettings:settings completion:^(Confiant * _Nullable _, NSError * _Nullable errorIfAny) {
        if (errorIfAny == nil) {
            NSLog(@"ConfiantSDK: Successfully initialized Confiant SDK");
        } else {
            NSError * _Nonnull error = errorIfAny;
            NSString * _Nonnull const message = [NSString stringWithFormat:@"ConfiantSDK: Failed to initialize Confiant SDK: %@ %ld", error.localizedDescription, (long)error.code];
            NSLog(@"ConfiantSDK: Error: %@", message);
            NSAssert(false, nil);
        }
    }];
}

@end
