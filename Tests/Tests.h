//
//  Tests.h
//  Tests
//
//  Created by André Dias on 13/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppDelegate.h"

@interface Tests : SenTestCase {
    @private
    AppDelegate* appDelegate;
    UISplitViewController* splitView;
}



@end
