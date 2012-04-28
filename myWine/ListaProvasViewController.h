//
//  ProvasViewController.h
//  myWine
//
//  Created by Antonio Velasquez on 3/20/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NovaProvaViewController.h"


@class ProvaViewController;

@interface ListaProvasViewController : UITableViewController <NovaProvaViewControllerDelegate>

@property (strong, nonatomic) ProvaViewController *provaViewController;

@property (strong, nonatomic) NSMutableArray* provas; 

@end
