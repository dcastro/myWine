//
//  LoginViewController.m
//  myWine
//
//  Created by Diogo Castro on 4/5/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "LoginViewController.h"
#import "Language.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize delegate = _delegate;
@synthesize frFlag = _frFlag;
@synthesize ptFlag = _ptFlag;
@synthesize enFlag = _enFlag;
@synthesize languageLabel = _languageLabel;
@synthesize usernameLabel = _usernameLabel;
@synthesize passwordLabel = _passwordLabel;
@synthesize welcomeLabel = _welcomeLabel;
@synthesize configLabel = _configLabel;
@synthesize loginButton = _loginButton;

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
    
    //flag buttons setup
    self.ptFlag.tag = PT;
    self.enFlag.tag = EN;
    self.frFlag.tag = FR;
    
    [self configureView];
}

- (void)viewDidUnload
{
    [self setFrFlag:nil];
    [self setPtFlag:nil];
    [self setEnFlag:nil];
    [self setLanguageLabel:nil];
    [self setUsernameLabel:nil];
    [self setPasswordLabel:nil];
    [self setWelcomeLabel:nil];
    [self setConfigLabel:nil];
    [self setLoginButton:nil];
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

    
    Language *lan = [Language sharedLanguage];
    NSLog(@"%d", [lan selectedLanguage]);
    NSLog(@"%@", [lan languageSelectedStringForKey:@"Welcome"]);
    
    //show alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan languageSelectedStringForKey:@"Welcome"] message:[lan languageSelectedStringForKey:@"Login Success"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    //dismiss the login controller
    [self.delegate LoginViewControllerDidLogin:self];
}

- (IBAction)selectLanguage:(id)sender {
    UIButton* selected = (UIButton*) sender;
    
    NSLog(@"%d", selected.tag);
    
    Language *lan = [Language sharedLanguage];
    lan.selectedLanguage = selected.tag;
    
    [self configureView];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)configureView {
    
    Language *lan = [Language sharedLanguage];
    
    self.languageLabel.text = [lan languageSelectedStringForKey:@"Language"];
    self.usernameLabel.text = [lan languageSelectedStringForKey:@"Username"];
    self.passwordLabel.text = [lan languageSelectedStringForKey:@"Password"];
    self.welcomeLabel.text = [lan languageSelectedStringForKey:@"Welcome to myWine"];
    self.configLabel.text = [lan languageSelectedStringForKey:@"Initial Configuration"];
    self.loginButton.titleLabel.text = [lan languageSelectedStringForKey:@"Login"];
    
    
    
}

@end
