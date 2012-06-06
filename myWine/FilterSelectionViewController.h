//
//  FilterSelectionViewController.h
//  myWine
//
//  Created by Diogo on 6/6/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@protocol FilterSelectionViewControllerDelegate <NSObject>

- (void) filterSelectionViewControllerDidSelect:(id) object;

@end


@interface FilterSelectionViewController : UITableViewController

@property (nonatomic) FilterType filterType;
@property (strong, nonatomic) id<FilterSelectionViewControllerDelegate> delegate;

@end
