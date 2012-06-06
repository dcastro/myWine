//
//  FilterViewController.h
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FilterTypeYear,
    FilterTypeCountry,
    FilterTypeWineType,
    FilterTypeRegion
} FilterType;

@class FilterSelectionViewController;
@protocol FilterSelectionViewControllerDelegate;

@interface FilterViewController : UITableViewController <FilterSelectionViewControllerDelegate>

@end
