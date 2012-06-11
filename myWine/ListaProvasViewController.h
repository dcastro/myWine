//
//  ProvasViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NovaProvaViewController.h"
#import "Prova.h"
#import "ProvaViewController.h"
#import "NSMutableArray+ProvasMutableArray.h"
#import "Language.h"
#import "FormularioProva.h"
#import "CheckboxButton.h"
#import "Comparator.h"
#import "ProvaCell.h"
#import "SubstitutableTabBarControllerViewController.h"

@protocol ListaProvasViewControllerDelegate <NSObject>

- (void) ListaProvasViewControllerDelegateDidUpdateScore;
- (void) goHome;

@end

@interface ListaProvasViewController : UITableViewController <NovaProvaViewControllerDelegate, SubstitutableTabBarControllerViewControllerDelegate>
{
    UISplitViewController *splitViewController;
    
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
}


@property (strong, nonatomic) NSMutableArray* provas; 
@property (strong, nonatomic) Vinho* vinho;

@property (nonatomic, strong) UISplitViewController *splitViewController;

@property (weak, nonatomic) UIPopoverController *currentPopover;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIBarButtonItem *rootPopoverButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *compareButton;

@property (nonatomic) BOOL needsEditing;

@property (strong, nonatomic) id<ListaProvasViewControllerDelegate> delegate;

@property (strong, nonatomic) SubstitutableTabBarControllerViewController* childDetail;

- (IBAction)addTasting:(id)sender;
- (IBAction)toggleComparison:(id)sender;

@end
