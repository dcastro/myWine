//
//  FilterViewController.h
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListaVinhosViewController.h"

typedef enum {
    FilterTypeYear,
    FilterTypeCountry,
    FilterTypeWineType,
    FilterTypeProducer
} FilterType;

@interface FilterViewController : UITableViewController <SubstitutableDetailViewController>

@property (nonatomic) FilterType selectedFilterType;

- (IBAction)clearAll:(id)sender;

@end
