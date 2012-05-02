//
//  DetailViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListaVinhosViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, SubstitutableDetailViewController> 

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) UIPopoverController *currentPopover;

@end
