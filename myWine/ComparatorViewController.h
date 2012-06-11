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

@interface ComparatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (strong, nonatomic) Prova* prova1;
@property (strong, nonatomic) Prova* prova2;
@property (strong, nonatomic) ProvaViewController* provaVC1;
@property (strong, nonatomic) ProvaViewController* provaVC2;


- (IBAction)cancel:(id)sender;

@end
