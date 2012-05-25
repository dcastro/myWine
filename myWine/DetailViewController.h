//
//  DetailViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListaVinhosViewController.h"
#import "Language.h"
@protocol SubstitutableDetailViewController;
@protocol DetailViewControllerDelegate <NSObject>

- (void) detailViewDidDisappear;
- (void) detailViewDidAppear;

@end

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, SubstitutableDetailViewController> 

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *info2Label;

@property (weak, nonatomic) UIPopoverController *currentPopover;

@property (strong, nonatomic) IBOutlet UIButton *search;
@property (strong, nonatomic) IBOutlet UIButton *sync;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *help;

@property (nonatomic, weak) id <DetailViewControllerDelegate> delegate;

@end
