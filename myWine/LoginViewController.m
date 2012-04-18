//
//  LoginViewController.m
//  myWine
//
//  Created by Diogo Castro on 4/5/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "LoginViewController.h"
#import "Language.h"
#import "User.h"
#import "ListaVinhosViewController.h"
#import "Vinho.h"

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
@synthesize usernameInput = _usernameInput;
@synthesize passwordInput = _passwordInput;

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
    [self setUsernameInput:nil];
    [self setPasswordInput:nil];
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

    
    Language *lan = [Language instance];
    NSLog(@"%d", [lan selectedLanguage]);
    NSLog(@"%@", [lan translate:@"Welcome"]);
    
    [User createWithUsername: self.usernameLabel.text Password: self.passwordLabel.text];
    User *user = [User instance];
    
    [user sync];
    
    
    //Login Successful
    if ( user.isValidated ) {
        //show alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan translate:@"Welcome"] message:[lan translate:@"Login Success"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        //dismiss the login controller
        [self.delegate LoginViewControllerDidLogin:self];
        ListaVinhosViewController* lvvc = (ListaVinhosViewController*) self.delegate;
        [lvvc setVinhos:user.vinhos];
        
        //save this user as default
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:user.user_id forKey:@"user_id"];
        [defaults synchronize];
        
        //reload master controller data
        [[lvvc tableView] reloadData];
        
        //Vinho* vinho = [[Vinho alloc] init];
        //vinho.name = @"Testing";
        //[lvvc.vinhos insertObject:vinho atIndex:0];
        //[lvvc insertNewObject:vinho];
        //NSLog(@"LOOOOOOOOL: %d", lvvc.vinhos.count);
        //NSLog(@"LOOOOOOOOL2: %d", user.vinhos.count);
        
    }
    //Login Failure
    else {
        //show alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[lan translate:@"Error"] message:[lan translate:@"Login Failure"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }

}

- (IBAction)selectLanguage:(id)sender {
    UIButton* selected = (UIButton*) sender;
    
    NSLog(@"%d", selected.tag);
    
    Language *lan = [Language instance];
    [lan setLang:selected.tag];
    
    [self configureView];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)configureView {
    
    Language *lan = [Language instance];
    
    self.languageLabel.text = [lan translate:@"Language"];
    self.usernameLabel.text = [lan translate:@"Username"];
    self.passwordLabel.text = [lan translate:@"Password"];
    self.welcomeLabel.text = [lan translate:@"Welcome to myWine"];
    self.configLabel.text = [lan translate:@"Initial Configuration"];
    self.loginButton.titleLabel.text = [lan translate:@"Login"];
    
    
    
}

@end
