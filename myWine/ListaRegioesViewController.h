//
//  ListaRegioesViewController.h
//  myWine
//
//  Created by Luis on 5/4/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Regiao.h"
#import "Pais.h"
#import "Language.h"

@protocol ListaRegioesViewControllerDelegate <NSObject>
- (void) selectedRegion:(Regiao*) region;
@end

@interface ListaRegioesViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray* regions;
@property (nonatomic, weak) id <ListaRegioesViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationItem *Regioes;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *Cancel;

- (IBAction)Cancel:(id)sender;

@end
