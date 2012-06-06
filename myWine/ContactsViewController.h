//
//  ContactsViewController.h
//  myWine
//
//  Created by André Dias on 01/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Language.h"

@interface ContactsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *contacts;
@property (strong, nonatomic) IBOutlet UILabel *telephonesLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *t1;
@property (weak, nonatomic) IBOutlet UILabel *t2;
@property (weak, nonatomic) IBOutlet UILabel *t3;
@property (weak, nonatomic) IBOutlet UILabel *t4;
@property (weak, nonatomic) IBOutlet UILabel *e1;
@property (weak, nonatomic) IBOutlet UILabel *e2;
@property (weak, nonatomic) IBOutlet UILabel *e3;
@property (weak, nonatomic) IBOutlet UILabel *e4;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabSelector;

@end
