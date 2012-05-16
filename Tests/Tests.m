//
//  Tests.m
//  Tests
//
//  Created by André Dias on 13/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tests.h"

@implementation Tests

- (void)setUp
{
    [super setUp];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    splitView = [appDelegate splitView];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testAppDelegate {
    STAssertNotNil(appDelegate, @"Cannot find the application delegate");
}

- (void)testExample
{
    
    //STFail(@"Unit tests are not implemented yet in Tests");
}

@end
