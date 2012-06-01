//
//  ListaPaisesViewController.h
//  myWine
//
//  Created by Diogo Castro on 04/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pais.h"
#import "User.h"
#import "Language.h"

@class ListaPaisesViewController;

@protocol ListaPaisesViewControllerDelegate <NSObject>
- (void) selectedCountry:(Pais*) country;
@end

@interface ListaPaisesViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *Paises;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *Cancel;


@property (nonatomic, weak) id <ListaPaisesViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* countries;

- (IBAction)Cancel:(id)sender;

@end
