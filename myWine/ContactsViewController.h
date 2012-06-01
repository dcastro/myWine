//
//  ContactsViewController.h
//  myWine
//
//  Created by André Dias on 01/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *telephonesLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *helpEmail;
@property (strong, nonatomic) IBOutlet UILabel *comercialEmail;
@property (strong, nonatomic) IBOutlet UILabel *onlineHelpLaber;
@property (strong, nonatomic) IBOutlet UITextView *onlineHelp;

@end
