//
//  ListaRegioesViewController.h
//  myWine
//
//  Created by Luis on 5/4/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Regiao.h"

@protocol ListaRegioesViewControllerDelegate <NSObject>
- (void) selectedRegion:(Regiao*) region;
@end

@interface ListaRegioesViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray* regions;
@property (nonatomic, weak) id <ListaRegioesViewControllerDelegate> delegate;


@end
