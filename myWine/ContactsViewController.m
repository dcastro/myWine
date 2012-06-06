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
@synthesize t1;
@synthesize t2;
@synthesize t3;
@synthesize t4;
@synthesize e1;
@synthesize e2;
@synthesize e3;
@synthesize e4;
@synthesize tabSelector;


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
	
    Language *lan = [Language instance];
    
	self.contacts.text = [lan translate:@"Contacts"];
    self.tabSelector.title = [lan translate:@"Contacts"];  
    self.contacts.font = [UIFont fontWithName:@"DroidSerif-Bold" size:TITLE_FONT];
    self.telephonesLabel.text = [lan translate:@"Telephones"];
    self.telephonesLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    self.emailsLabel.text = [lan translate:@"E-mails"];
    self.emailsLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:SMALL_FONT];
    
    self.t1.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.t2.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.t3.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.t4.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.e1.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.e2.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.e3.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];
    self.e4.font = [UIFont fontWithName:@"DroidSans" size:SMALL_FONT-2];

}

- (void)viewDidUnload
{
    [self setTelephonesLabel:nil];
    [self setEmailsLabel:nil];
    [self setContacts:nil];
    [self setT1:nil];
    [self setT2:nil];
    [self setT3:nil];
    [self setT4:nil];
    [self setE1:nil];
    [self setE2:nil];
    [self setE3:nil];
    [self setE4:nil];
    [self setTabSelector:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
