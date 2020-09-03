//
//  FreestarAdsTests.m
//  FreestarAdsTests
//
//  Created by Lev Trubov on 9/2/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

#import <XCTest/XCTest.h>
@import FreestarAds;

@interface FreestarAdsLaunchAndDataTests : XCTestCase

@end

@implementation FreestarAdsLaunchAndDataTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAppName {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertEqualObjects(@"FreestarAds-Swift", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]);
}

- (void)testAPIKey {
    XCTAssertEqualObjects([Freestar getAdUnitID], @"X4mdFv");
}



@end
