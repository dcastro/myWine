//
//  ComparatorViewController.h
//  myWine
//
//  Created by Diogo Castro on 10/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Prova;
@class ProvaViewController;

@interface ComparatorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (strong, nonatomic) Prova* provaA;
@property (strong, nonatomic) Prova* provaB;

@property (weak, nonatomic) IBOutlet UITableView *tableViewA;
@property (weak, nonatomic) IBOutlet UITableView *tableViewB;
@property (weak, nonatomic) IBOutlet UILabel *scoreContentLabelA;
@property (weak, nonatomic) IBOutlet UILabel *scoreContentLabelB;

- (IBAction)cancel:(id)sender;

@end
