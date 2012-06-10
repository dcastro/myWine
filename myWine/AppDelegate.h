//
//  AppDelegate.h
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@class MySplitViewViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *overlayWindow;

@property (strong, nonatomic) MySplitViewViewController* splitView;
@property (strong, nonatomic) UINavigationController* comparatorNavController;

-(void) showComparator;
-(void) hideComparator;

@end
