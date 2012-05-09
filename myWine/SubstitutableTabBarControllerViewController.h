//
//  SubstitutableTabBarControllerViewController.h
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubstitutableDetailViewController;

@interface SubstitutableTabBarControllerViewController : UITabBarController <SubstitutableDetailViewController>

@end
