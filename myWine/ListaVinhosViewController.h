//
//  MasterViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/19/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NovoVinhoViewController.h"


@class DetailViewController;

@interface ListaVinhosViewController : UITableViewController <NovoVinhoViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
