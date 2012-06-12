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
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UILabel *provaAlabel;
@property (weak, nonatomic) IBOutlet UILabel *provaBlabel;
@property (weak, nonatomic) IBOutlet UILabel *provaAdate;
@property (weak, nonatomic) IBOutlet UILabel *provaBdate;

- (IBAction)cancel:(id)sender;

@end
