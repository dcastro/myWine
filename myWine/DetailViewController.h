//
//  DetailViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language.h"
#import "MySplitViewViewController.h"

@protocol DetailViewControllerDelegate <NSObject>

- (void) detailViewDidDisappear;
- (void) detailViewDidAppear;

@end

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, TranslatableViewController> 

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) UIPopoverController *currentPopover;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *help;
@property (strong, nonatomic) IBOutlet UILabel *myWine;

@property (nonatomic, weak) id <DetailViewControllerDelegate> delegate;


-(void) translate;

@end
