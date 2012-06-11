//
//  ListaVinhosViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NovoVinhoViewController.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "VinhoViewController.h"
#import "OrderViewController.h"
#import "ListaProvasViewController.h"


@class DetailViewController;
@class VinhoViewController;
@protocol VinhoViewControllerDelegate;
@protocol DetailViewControllerDelegate;
@protocol LoginViewControllerDelegate;
@protocol SubstitutableDetailViewController <NSObject>

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;

@end

@interface ListaVinhosViewController : UITableViewController < UISplitViewControllerDelegate, VinhoViewControllerDelegate, DetailViewControllerDelegate, NovoVinhoViewControllerDelegate, LoginViewControllerDelegate, OrderViewControllerDelegate, ListaProvasViewControllerDelegate>
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
@property (nonatomic) int selectedOrder;


@property (nonatomic, getter=homeIsVisible) BOOL homeVisibility;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *tempButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *orderButton;

- (void)insertNewObject:(id)sender;

- (void) setVinhos:(NSMutableArray*)vinhos;

- (void) configureView;
- (IBAction)didPressHomeButton:(id)sender;

-(void) reloadData;

- (void) goHome;


@end
