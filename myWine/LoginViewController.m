//
//  LoginViewController.m
//  myWine
//
//  Created by Diogo Castro on 4/5/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "LoginViewController.h"
#import "ListaVinhosViewController.h"

@interface LoginViewController (){
    CGFloat animatedDistance;
    UITextField *keyboard;
}


@end

@implementation LoginViewController

@synthesize delegate = _delegate;
@synthesize frFlag = _frFlag;
@synthesize ptFlag = _ptFlag;
@synthesize enFlag = _enFlag;
@synthesize usernameLabel = _usernameLabel;
@synthesize passwordLabel = _passwordLabel;
@synthesize welcomeLabel = _welcomeLabel;
@synthesize configLabel = _configLabel;
@synthesize loginButton = _loginButton;
@synthesize usernameInput = _usernameInput;
@synthesize passwordInput = _passwordInput;
@synthesize editing = _editing;


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
    
    // Setup the background
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPortrait.png"]]];
    }
    else 
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    }
    
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
    
    Language *lan = [Language instance];
    
    [User createWithUsername: self.usernameInput.text Password: self.passwordInput.text];
    User *user = [User instance];
    
#warning TODO: FERNANDO: sync
    //Vinho* vinho = [[Vinho alloc] init];
    //vinho.name = @"Testing";
    //[user.vinhos insertObject:vinho atIndex:0];
    
    
    //Login Successful
    if ( user.isValidated ) {
        //dismiss the login controller
        [self.delegate LoginViewControllerDidLogin:self];
        ListaVinhosViewController* lvvc = (ListaVinhosViewController*) self.delegate;
        [lvvc setVinhos:user.vinhos];
        [lvvc reloadData];
        
        //save this user as default
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:user.username forKey:@"username"];
        [defaults synchronize];
        
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
    
    Language *lan = [Language instance];
    [lan setLang:selected.tag];
    
    [self configureView];
    ListaVinhosViewController* lvvc = (ListaVinhosViewController*) self.delegate;
    [lvvc configureView];
    
}

// allows next button on keyboard to move onto the next text field
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Setup the background
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPortrait.png"]]];
    }
    else 
    {
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLandscape.png"]]];
    }
    
    if(_editing){
        
        CGRect viewFrame = self.view.frame;
        
        if (orientation == UIInterfaceOrientationLandscapeRight){
            animatedDistance = 235;
            viewFrame.origin.x += animatedDistance;
        }   
        else if (orientation == UIInterfaceOrientationLandscapeLeft){
            animatedDistance = 235;
            viewFrame.origin.x -= animatedDistance;
        }
        else if(orientation == UIInterfaceOrientationPortrait){
            animatedDistance = 0;
        }
        else if(orientation == UIInterfaceOrientationPortraitUpsideDown){
            animatedDistance = 0;
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        
        [self.view setFrame:viewFrame];
        
        [UIView commitAnimations];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _editing = true;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect viewFrame = self.view.frame;
    
    if (orientation == UIInterfaceOrientationLandscapeRight){
        animatedDistance = 235;
        viewFrame.origin.x += animatedDistance;
    }   
    else if (orientation == UIInterfaceOrientationLandscapeLeft){
        animatedDistance = 235;
        viewFrame.origin.x -= animatedDistance;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _editing = false;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect viewFrame = self.view.frame;
    
    if (orientation == UIInterfaceOrientationLandscapeRight){
        viewFrame.origin.x -= animatedDistance;
        animatedDistance = 0;
    }   
    else if (orientation == UIInterfaceOrientationLandscapeLeft){
        viewFrame.origin.x += animatedDistance;
        animatedDistance = 0;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)configureView {
    
    Language *lan = [Language instance];
    self.usernameInput.delegate = self;
    self.passwordInput.delegate = self;
    self.passwordInput.placeholder = [lan translate:@"Password"];
    self.usernameInput.placeholder = [lan translate:@"Username"];
    self.welcomeLabel.text = [lan translate:@"Welcome to myWine"];
    self.welcomeLabel.font = [UIFont fontWithName:@"DroidSerif-Bold" size:TITLE_FONT];
    self.configLabel.text = [lan translate:@"Initial Configuration"];
    self.configLabel.font = [UIFont fontWithName:@"DroidSans" size:NORMAL_FONT];
    [self.loginButton setTitle:[lan translate:@"Login"] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"DroidSans" size:LARGE_FONT];
}

@end
