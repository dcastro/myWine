//
//  FilterSelectionViewController.h
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"
#import "ListaVinhosViewController.h"
#import "MySplitViewViewController.h"

@interface FilterSelectionViewController : UITableViewController <SubstitutableDetailViewController, TranslatableViewController>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearAllButton;
@property (nonatomic) FilterType filterType;
@property (strong, nonatomic) NSArray* objects;

@property (strong, nonatomic) id delegate;


- (IBAction)clearAll:(id)sender;

- (void) translate;

@end
