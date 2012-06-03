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

@interface ListaProvasViewController : UITableViewController <NovaProvaViewControllerDelegate>
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

- (IBAction)addTasting:(id)sender;

@end
