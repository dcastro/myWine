//
//  SubstitutableTabBarControllerViewController.h
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvaViewController.h"
#import "MySplitViewViewController.h"

@protocol SubstitutableDetailViewController;

@protocol SubstitutableTabBarControllerViewControllerDelegate <NSObject>

- (void) SubstitutableTabBarControllerViewControllerDidUpdateScore;

@end


@interface SubstitutableTabBarControllerViewController : UITabBarController <SubstitutableDetailViewController, ProvaViewControllerDelegate, UITabBarControllerDelegate, TranslatableViewController>

@property (strong, nonatomic) Vinho* vinho;
@property (strong, nonatomic) Prova* prova;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) UIBarButtonItem* tempButton;

@property (strong, nonatomic) ProvaViewController* criteriaController;
@property (strong, nonatomic) ProvaViewController* characteristicsController;

@property (nonatomic) BOOL needsEditing;

@property (strong, nonatomic) id<SubstitutableTabBarControllerViewControllerDelegate> myDelegate;

- (IBAction)toggleEdit:(id)sender;

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;

- (void) translate;

@end
