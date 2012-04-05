//
//  LoginViewController.m
//  myWine
//
//  Created by Diogo Castro on 4/5/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize delegate = _delegate;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)doLogin:(id)sender {
    NSLog(@"Logging in");
    NSLog(@"LoginController's delegate: %@", self.delegate);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bem Vindo!" message:@"Login efectuado com sucesso" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [self.delegate LoginViewControllerDidLogin:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
