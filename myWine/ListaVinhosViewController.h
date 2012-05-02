//
//  MasterViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NovoVinhoViewController.h"
#import "LoginViewController.h"

@class DetailViewController;
@class VinhoViewController;
@protocol VinhoViewControllerDelegate;

@protocol SubstitutableDetailViewController <NSObject>

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;

@end



@interface ListaVinhosViewController : UITableViewController <NovoVinhoViewControllerDelegate, LoginViewControllerDelegate, UISplitViewControllerDelegate, VinhoViewControllerDelegate>
{
    UISplitViewController *splitViewController;
    
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) VinhoViewController *vvc;

@property (strong, nonatomic) NSMutableArray* vinhos;

@property (weak, nonatomic) UIPopoverController *currentPopover;

@property (nonatomic, strong) UISplitViewController *splitViewController;

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIBarButtonItem *rootPopoverButtonItem;

- (void)insertNewObject:(id)sender;

- (void) setVinhos:(NSMutableArray*)vinhos;

- (void) configureView;

@end
