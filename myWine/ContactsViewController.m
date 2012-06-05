//
//  ContactsViewController.m
//  myWine
//
//  Created by André Dias on 01/06/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController
@synthesize contacts;
@synthesize telephonesLabel;
@synthesize emailsLabel;
@synthesize helpEmail;
@synthesize comercialEmail;
@synthesize onlineHelpLaber;
@synthesize onlineHelp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTelephonesLabel:nil];
    [self setEmailsLabel:nil];
    [self setHelpEmail:nil];
    [self setComercialEmail:nil];
    [self setOnlineHelpLaber:nil];
    [self setOnlineHelp:nil];
    [self setContacts:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
