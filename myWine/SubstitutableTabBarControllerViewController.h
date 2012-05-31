//
//  SubstitutableTabBarControllerViewController.h
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vinho.h"
#import "Prova.h"
#import "Language.h"
#import "ProvaViewController.h"
#import "ListaVinhosViewController.h"

@class ProvaViewController;
@protocol SubstitutableDetailViewController;

@interface SubstitutableTabBarControllerViewController : UITabBarController <SubstitutableDetailViewController>

@property (strong, nonatomic) Vinho* vinho;
@property (strong, nonatomic) Prova* prova;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) UIBarButtonItem* tempButton;

@property (strong, nonatomic) ProvaViewController* pcvc;

- (IBAction)toggleEdit:(id)sender;

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;

@end
