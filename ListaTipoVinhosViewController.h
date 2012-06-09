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
#import "Language.h"

@class ListaTipoVinhosViewController;

@protocol ListaTipoVinhosViewControllerDelegate <NSObject>
- (void) selectedType:(TipoVinho*) type;
@end


@interface ListaTipoVinhosViewController : UITableViewController

@property (nonatomic, weak) id <ListaTipoVinhosViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Cancel;
@property (weak, nonatomic) IBOutlet UINavigationItem *TipoVinhoBar;

@property (nonatomic, strong) NSMutableArray* tipos;
- (IBAction)Cancel:(id)sender;

@end
