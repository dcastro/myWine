//
//  MySplitViewViewController.h
//  myWine
//
//  Created by Diogo Castro on 10/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TranslatableViewController <NSObject>

- (void) translate;

@end

@interface MySplitViewViewController : UISplitViewController

@property (nonatomic) BOOL shouldRotate;

- (void) translate;

-(void)dismiss;

@end
