//
//  ListaTipoVinhosViewController.h
//  myWine
//
//  Created by Luis on 6/8/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipoVinho.h"
#import "User.h"

@class ListaTipoVinhosViewController;

@protocol ListaTipoVinhosViewControllerDelegate <NSObject>
- (void) selectedType:(TipoVinho*) Type;
@end


@interface ListaTipoVinhosViewController : UITableViewController

@property (nonatomic, weak) id <ListaTipoVinhosViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray* tipos;

@end
