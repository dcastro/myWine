//
//  FilterViewController.h
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListaVinhosViewController.h"
#import "MySplitViewViewController.h"

typedef enum {
    FilterTypeYear,
    FilterTypeCountry,
    FilterTypeWineType,
    FilterTypeProducer,
    FilterTypeCount
} FilterType;

@interface FilterViewController : UITableViewController <SubstitutableDetailViewController, TranslatableViewController>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearAllButton;
@property (nonatomic) FilterType selectedFilterType;

- (IBAction)clearAll:(id)sender;

- (void) translate;

@end
